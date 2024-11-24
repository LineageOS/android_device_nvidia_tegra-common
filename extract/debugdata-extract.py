from elftools.elf.elffile import ELFFile, Section, SymbolTableSection
from lzma import LZMADecompressor, FORMAT_XZ
from os import remove
import sys

def get_debug_symbols(filename):
    print('Processing file:', filename)
    with open(filename, 'rb') as f:
        try:
            elffile = ELFFile(f)
        except:
            print('  The file is not an elf file')
            return []

        section_name = '.gnu_debugdata'
        debugdata = elffile.get_section_by_name(section_name)

        if not isinstance(debugdata, Section):
            print('  The file has no %s section' % section_name)
            return []
        print('  Found %s section' % section_name)

        debugdata_filename = filename + '-symbols.elf'
        with open(debugdata_filename, 'wb') as f:
            print('    Extracting...')
            decompressor = LZMADecompressor(FORMAT_XZ)
            data = decompressor.decompress(debugdata.data())
            f.write(data)

    symbols = []
    with open(debugdata_filename, 'rb') as f:
        elffile = ELFFile(f)

        symbol_tables = [s for s in elffile.iter_sections() if isinstance(s, SymbolTableSection)]

        if not symbol_tables and elffile.num_sections() == 0:
            print('    INFO: No debug symbols.')

        for section in symbol_tables:
            symbols += [(symbol['st_value'], symbol.name) for symbol in section.iter_symbols() if len(symbol.name) != 0]
    remove(debugdata_filename)
    return symbols

def main(filename):
    symbols = get_debug_symbols(filename)

    if symbols:
        with open(filename + '-syms.json', 'w') as f:
            f.write('{\n')
            first = True
            for offset, name in symbols:
                f.write((',\n' if not first else "") + '	"0x%X" : "%s"' % (offset, name))
                first = False
            f.write('}\n')


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('usage: debugdata-extract.py [elf files...]')
        print('writes output to input filename + "-syms.json"')
    for filename in sys.argv[1:]:
        main(filename)
