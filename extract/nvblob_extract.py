#!/usr/bin/python
"""
Extracts NVIDIA bootloader blobs
"""

import os
import struct
import sys

def main(blobpath, outpath):
    secure_header_packing = '=20sII'
    secure_header_name_tuple = ("magic", "blob_size", "header_size")
    header_packing = '=16sIIIII'
    header_name_tuple = ("magic", "version", "blob_size", "header_size", "entry_count", "type", "uncomp_blob_size")
    uncomp_packing = '=I'

    with open(blobpath, 'rb') as blob_file:
        # Detect signature header, not important other than adding offsets to all reads
        secure_header_tuple = list(struct.unpack(secure_header_packing, blob_file.read(struct.calcsize(secure_header_packing))))
        secure_header_dict = dict(zip(secure_header_name_tuple, secure_header_tuple))
        secure_offset = 0
        if secure_header_dict['magic'].decode('utf-8') == '-SIGNED-BY-SIGNBLOB-':
            secure_offset = struct.calcsize(secure_header_packing)
        blob_file.seek(secure_offset)

        # Read header and detect version, note that magic V2 is used in two different variants
        blob_header_tuple = list(struct.unpack(header_packing, blob_file.read(struct.calcsize(header_packing))))
        blob_header_dict = dict(zip(header_name_tuple, blob_header_tuple))

        header_verison = -1
        if  blob_header_dict['magic'].decode('utf-8') == 'NVIDIA__BLOB__V2':
            header_version = 1
        elif  blob_header_dict['magic'].decode('utf-8') == 'NVIDIA__BLOB__V3':
            header_version = 3
        elif blob_header_dict['magic'].decode('utf-8') == 'MSM-RADIO-UPDATE':
            header_version = 0
        else:
            print("Not a NVIDIA blob!")
            return

        # Check if header contains uncompressed size. If so, this is the second of the magic V2 variants
        if blob_header_dict['header_size'] > struct.calcsize(header_packing):
            if header_version == 1:
                header_version = 2

            # Decompression in python is apparently more difficult than it should be
            blob_header_dict['uncomp_blob_size'] = struct.unpack(uncomp_packing, blob_file.read(struct.calcsize(uncomp_packing)))[0]
            if blob_header_dict['uncomp_blob_size'] > blob_header_dict['blob_size']:
                print("Compressed blob unsupported")
                return


        blob_entry_list = list(range(blob_header_dict['entry_count']))
        blob_file.seek(blob_header_dict['header_size'] + secure_offset)

        # The first magic V2 variant can still be compressed. Only lz4 has been observed in use.
        # This needs to be decompressed and reassembled outside of this script.
        if (int.from_bytes(blob_file.read(4)) == 0x02214c18):
            print("LZ4 compressed blob unsupported")
            return
        else:
            blob_file.seek(blob_file.tell() - 4)

        match blob_header_dict['type']:
            # This is an update blob
            case 0:
                print("Extracting bootloader update with header version " + str(header_version))

                # Choose entry table format based on header version
                entry_packing_list = ('=4sIII', '=40sIII', '=40sIIII64s', '=40sIIII128s')
                entry_name_tuple = ("part_name", "offset", "part_size", "version", "op_mode", "tnspec")
                entry_packing = entry_packing_list[header_version]

                # Build entry table
                for idx in range(blob_header_dict['entry_count']):
                    blob_entry_tuple = struct.unpack(entry_packing, blob_file.read(struct.calcsize(entry_packing)))
                    blob_entry_list[idx] = dict(zip(entry_name_tuple, blob_entry_tuple))

                idx_dict = {}
                for blob_entry in blob_entry_list:
                    # Get name from entry table and strip whitespace
                    name = blob_entry['part_name'].decode('utf-8').strip(' \t\n\0')

                    # If the entry table contains the tnspec field, put that in the name
                    # An empty tnspec indicates 'common', something that is installed to all variants
                    if header_version >= 2 and blob_entry['tnspec'].decode('utf-8').strip(' \t\n\0'):
                        name += '_' + blob_entry['tnspec'].decode('utf-8').strip(' \t\n\0')

                    # Header versions 1 and 2 can contain duplicate entries, meant for use with DTBs
                    # The bootloader will compare dtbfilename in the DTB with the running devices DT
                    # This will add an incrementing number to the name for every duplicate found
                    if idx_dict.get(name) is None:
                        idx_dict[name] = 1
                    else:
                        idx_dict[name] += 1
                        name += '_' + str(idx_dict[name])
                    part_path = os.path.join(outpath, name)

                    if os.path.isfile(part_path):
                        print("x Not overwriting " + name)
                        continue

                    print("* Writing " + name)

                    # Write the entry data to disk
                    with open(part_path, 'wb') as outfile:
                        blob_file.seek(blob_entry['offset'] + secure_offset)
                        outfile.write(blob_file.read(blob_entry['part_size']))

            case 1:
                print("Extracting bmp blob")

                # This entry format is only valid on header version 1 and newer, nothing using the oldest format was publicly released
                entry_packing = '=IIII36s'
                entry_name_tuple = ("type", "offset", "size", "resolution", "reserved")
                name_list = ("nvidia", "lowbatt", "charging", "charged", "fullycharged", "sata_fw_ota", "verity_yellow_pause_", "verity_yellow_continue_", "verity_orange_pause_", "verity_orange_continue_", "verity_red_pause_", "verity_red_continue_", "verity_red_stop_", "verity_eio_continue_", "verity_eio_stop_")
                res_list = ("480", "720", "810", "1080", "4k", "1200_p")

                # Build entry table
                for idx in range(blob_header_dict['entry_count']):
                    blob_entry_tuple = struct.unpack(entry_packing, blob_file.read(struct.calcsize(entry_packing)))
                    blob_entry_list[idx] = dict(zip(entry_name_tuple, blob_entry_tuple))

                for idx, blob_entry in enumerate(blob_entry_list):
                    # Name is built based on a table lookup of type and resolution to match what nvidia used in public bsp releases
                    name = name_list[blob_entry['type']] + res_list[blob_entry['resolution']] + ".bmp"
                    bmp_path = os.path.join(outpath, name)

                    if os.path.isfile(bmp_path):
                        print("x Not overwriting " + name)
                        continue

                    print("* Writing " + name)

                    # Write the entry data to disk
                    with open(bmp_path, 'wb') as outfile:
                        blob_file.seek(blob_entry['offset'] + secure_offset)
                        outfile.write(blob_file.read(blob_entry['size']))

            case _:
                print("Unsupported blob type!")
                return


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
