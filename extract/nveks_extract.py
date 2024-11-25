#!/usr/bin/python
"""
Extracts NVIDIA bootloader blobs
"""

import os
import struct
import sys
import uuid

from Crypto.Util.py3compat import bchr, bord
from Crypto.Cipher import AES
from binascii import hexlify, unhexlify

def pad(data_to_pad, block_size):
    padding_len = block_size-len(data_to_pad)%block_size
    padding = bchr(padding_len)*padding_len
    return data_to_pad + padding

def unpad(padded_data, block_size):
    pdata_len = len(padded_data)
    if not pdata_len % block_size:
        raise ValueError("Input data is not padded")
    padding_len = bord(padded_data[-1])
    if padding_len<1: #or padding_len>min(block_size, pdata_len):
        raise ValueError("Padding is incorrect. " + str(padding_len))
    if padded_data[-padding_len:]!=bchr(padding_len)*padding_len:
        raise ValueError("PKCS#7 padding is incorrect.")
    return padded_data[:-padding_len]

def main(ekspath, sbkstr):
    header_packing = '=I8s'
    header_name_tuple = ("eks_size", "magic")
    eks_header_packing = '=I'
    eks_header_name_tuple = ("entry_count")
    eks_entry_packing = '=I16s'
    eks_entry_name_tuple = ("algo_type", "tos_uuid")
    eks2_header_packing = '=IxxxxI'
    eks2_header_name_tuple = ("version", "entry_count")
    ekb_header_packing = '=HH'
    ekb_header_name_tuple = ("major_version", "minor_version")
    ekb0_header_packing = '=2Q2Q'
    ekb0_header_name_tuple = ("mac1", "mac2", "iv1", "iv2")
    ekb1_header_packing = '=2QI4sxxxxxxxx2Q'
    ekb1_header_name_tuple = ("mac1", "mac2", "content_size", "content_magic", "iv1", "iv2")
    ekb2_header_packing = '=2Q2QI4sxxxxxxxx2Q'
    ekb2_header_name_tuple = ("fv1", "fv2", "mac1", "mac2", "content_size", "content_magic", "iv1", "iv2")

    with open(ekspath, 'rb') as eks_file:
        header_tuple = list(struct.unpack(header_packing, eks_file.read(struct.calcsize(header_packing))))
        header_dict = dict(zip(header_name_tuple, header_tuple))
        eks_type = header_dict['magic'].decode('utf-8').strip(' \t\n\0')

        if   eks_type == 'NVEKSP':
            print("Found EKS")
            eks_header_tuple = list(struct.unpack(eks_header_packing, eks_file.read(struct.calcsize(eks_header_packing))))
            eks_header_dict = dict(zip(eks_header_name_tuple, eks_header_tuple))
            print("Count: " + str(eks_header_dict['e']))

            iv = unhexlify("00000000000000000000000000000000")
            sbk = unhexlify(sbkstr)
            for idx in range(eks_header_dict['e']):
                entry_size = int.from_bytes(eks_file.read(4), byteorder='little')
                if entry_size != 0:
                    cipher = AES.new(sbk, AES.MODE_CBC, iv)
                    cipher_text = cipher.encrypt(pad(unhexlify("59e2636124674ccd840cb42c8e84f116"), AES.block_size))
                    decipher = AES.new(unhexlify(cipher_text.hex()[:32]), AES.MODE_CBC, iv)
                    keydata = decipher.decrypt(eks_file.read(entry_size).strip(b'\x00'))
                    eks_entry_tuple = list(struct.unpack(eks_entry_packing, keydata[:20]))
                    eks_entry_dict = dict(zip(eks_entry_name_tuple, eks_entry_tuple))
                    print("Key index: " + str(idx))
                    print("TOS UUID:  " + str(uuid.UUID(eks_entry_dict['tos_uuid'].hex())))
                    if eks_entry_dict['algo_type'] == 3:
                        decipher = AES.new(unhexlify(cipher_text.hex()[:32]), AES.MODE_ECB)
                    print("Key:       " + str(decipher.decrypt(unpad(keydata[20:], AES.block_size)).hex()))

        elif eks_type == 'NVEKSP2':
            eks2_header_tuple = list(struct.unpack(eks2_header_packing, eks_file.read(struct.calcsize(eks2_header_packing))))
            eks2_header_dict = dict(zip(eks2_header_name_tuple, eks2_header_tuple))
            print("Found EKS2 v" + str(eks2_header_dict['version']))
            print("Count: " + str(eks2_header_dict['entry_count']))

            for idx in range(eks2_header_dict['entry_count']):
                entry_size = int.from_bytes(eks_file.read(4), byteorder='little')
                print("Entry size: " + str(entry_size))
                print("Encrypted data: " + eks_file.read(entry_size).hex())
        elif eks_type == 'NVEKBP':
            ekb_header_tuple = list(struct.unpack(ekb_header_packing, eks_file.read(struct.calcsize(ekb_header_packing))))
            ekb_header_dict = dict(zip(ekb_header_name_tuple, ekb_header_tuple))
            print("Found EKB v" + str(ekb_header_dict['major_version']) + "." + str(ekb_header_dict['minor_version']))

            if   ekb_header_dict['major_version'] == 0:
                ekb0_header_tuple = list(struct.unpack(ekb0_header_packing, eks_file.read(struct.calcsize(ekb0_header_packing))))
                ekb0_header_dict = dict(zip(ekb0_header_name_tuple, ekb0_header_tuple))
                print("Cmac: " + "0x%0.16X" % ekb0_header_dict['mac2'] + "%0.16X" % ekb0_header_dict['mac1'])
                iv = (ekb0_header_dict['iv2'] << 64) + ekb0_header_dict['iv1']
                print("IV:   " + "0x%0.32X" % iv)
                sbk = unhexlify(sbkstr)
                decipher = AES.new(sbk, AES.MODE_CBC, iv.to_bytes(16, 'big'))
                #content_size = header_dict['eks_size'] - struct.calcsize('=8s') - struct.calcsize(ekb_header_packing) - struct.calcsize(ekb0_header_packing)
                content_size = 16
                #print("Key:  " + str(decipher.decrypt(unpad(eks_file.read(content_size), AES.block_size)).hex()))
                print("Key:  " + str(decipher.decrypt(eks_file.read(content_size)).hex()))

                # Do something with the encrypted data
            elif ekb_header_dict['major_version'] == 1:
                ekb1_header_tuple = list(struct.unpack(ekb1_header_packing, eks_file.read(struct.calcsize(ekb1_header_packing))))
                ekb1_header_dict = dict(zip(ekb1_header_name_tuple, ekb1_header_tuple))
                print("Cmac: " + "0x%0.16X" % ekb1_header_dict['mac2'] + "%0.16X" % ekb1_header_dict['mac1'])
                print("IV:   " + "0x%0.16X" % ekb1_header_dict['iv2']  + "%0.16X" % ekb1_header_dict['iv1'])
                print("Content Size:  " + str(ekb1_header_dict['content_size']))
                print("Content Magic: " + ekb1_header_dict['content_magic'].decode('utf-8').strip(' \t\n\0'))

                # Do something with the encrypted data
            elif ekb_header_dict['major_version'] == 2:
                ekb2_header_tuple = list(struct.unpack(ekb2_header_packing, eks_file.read(struct.calcsize(ekb2_header_packing))))
                ekb2_header_dict = dict(zip(ekb2_header_name_tuple, ekb2_header_tuple))
                print("FV:   " + "0x%0.16X" % ekb2_header_dict['fv2']  + "%0.16X" % ekb2_header_dict['fv1'])
                print("Cmac: " + "0x%0.16X" % ekb2_header_dict['mac2'] + "%0.16X" % ekb2_header_dict['mac1'])
                print("IV:   " + "0x%0.16X" % ekb2_header_dict['iv2']  + "%0.16X" % ekb2_header_dict['iv1'])
                print("Content Size:  " + str(ekb2_header_dict['content_size']))
                print("Content Magic: " + ekb2_header_dict['content_magic'].decode('utf-8').strip(' \t\n\0'))

                # Do something with the encrypted data
            else:
                print("Unknown EKB version!")
        else:
            print("Not a NVIDIA key blob!")
            return


if __name__ == "__main__":
    if len(sys.argv) < 3:
        main(sys.argv[1], "00000000000000000000000000000000")
    else:
        main(sys.argv[1], sys.argv[2])
