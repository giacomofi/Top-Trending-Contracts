['/*\n', ' * DO NOT EDIT! DO NOT EDIT! DO NOT EDIT!\n', ' *\n', ' * This is an automatically generated file. It will be overwritten.\n', ' *\n', ' * For the original source see\n', ' *    &#39;/Users/swaldman/Dropbox/BaseFolders/development-why/gitproj/eth-fortune/src/main/solidity/Fortune.sol&#39;\n', ' */\n', '\n', 'pragma solidity ^0.4.10;\n', '\n', 'contract Fortune {\n', '  string[] public fortunes; // automatically generates an indexed getter (only)\n', '\n', '  function Fortune( string initialFortune ) public {\n', '    addFortune( initialFortune );\n', '  }\n', '\n', '  function addFortune( string fortune ) public {\n', '    fortunes.push( fortune );\n', '\n', '    FortuneAdded( msg.sender, fortune );\n', '  }\n', '\n', '  function drawFortune() public view returns ( string fortune ) {\n', '    fortune = fortunes[ shittyRandom() % fortunes.length ];\n', '  }\n', '\n', '  function countFortunes() public view returns ( uint count ) {\n', '    count = fortunes.length;\t   \n', '  }\n', '\n', '  function shittyRandom() private view returns ( uint number ) {\n', '    number = uint( block.blockhash( block.number - 1 ) );  \t   \n', '  }\n', '\n', '  event FortuneAdded( address author, string fortune );\t\n', '}']
['/*\n', ' * DO NOT EDIT! DO NOT EDIT! DO NOT EDIT!\n', ' *\n', ' * This is an automatically generated file. It will be overwritten.\n', ' *\n', ' * For the original source see\n', " *    '/Users/swaldman/Dropbox/BaseFolders/development-why/gitproj/eth-fortune/src/main/solidity/Fortune.sol'\n", ' */\n', '\n', 'pragma solidity ^0.4.10;\n', '\n', 'contract Fortune {\n', '  string[] public fortunes; // automatically generates an indexed getter (only)\n', '\n', '  function Fortune( string initialFortune ) public {\n', '    addFortune( initialFortune );\n', '  }\n', '\n', '  function addFortune( string fortune ) public {\n', '    fortunes.push( fortune );\n', '\n', '    FortuneAdded( msg.sender, fortune );\n', '  }\n', '\n', '  function drawFortune() public view returns ( string fortune ) {\n', '    fortune = fortunes[ shittyRandom() % fortunes.length ];\n', '  }\n', '\n', '  function countFortunes() public view returns ( uint count ) {\n', '    count = fortunes.length;\t   \n', '  }\n', '\n', '  function shittyRandom() private view returns ( uint number ) {\n', '    number = uint( block.blockhash( block.number - 1 ) );  \t   \n', '  }\n', '\n', '  event FortuneAdded( address author, string fortune );\t\n', '}']