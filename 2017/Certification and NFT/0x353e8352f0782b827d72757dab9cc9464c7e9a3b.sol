['/*\n', ' * DO NOT EDIT! DO NOT EDIT! DO NOT EDIT!\n', ' *\n', ' * This is an automatically generated file. It will be overwritten.\n', ' *\n', ' * For the original source see\n', " *    '/Users/swaldman/Dropbox/BaseFolders/development-why/gitproj/eth-ping-pong/src/main/solidity/PingPong.sol'\n", ' */\n', '\n', 'pragma solidity ^0.4.18;\n', '\n', '\n', '\n', '\n', '\n', 'contract PingPong {\n', '  string private last;\n', '  uint private pong_count;\n', '\n', '  function PingPong() public {\n', '    last = "";\n', '    pong_count = 0;\n', '  }\n', '\n', '  event Pinged( string payload );\n', '  event Ponged( uint indexed count, string payload );\n', '\n', '  function ping( string payload ) public {\n', '    last = payload;\n', '\n', '    Pinged( payload );\n', '  }\n', '\n', '  function pong() public {\n', '    pong_count += 1;\n', '\n', '    Ponged( pong_count, last );\n', '  }\n', '\n', '  function count() public view returns (uint n) {\n', '    n = pong_count;\n', '  }\n', '}']