['pragma solidity ^0.4.15;\n', '\n', 'contract ThanahCoin {\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\n', '    uint public totalSupply;\n', '    uint public availableSupply;\n', '    mapping (address => uint256) public balanceOf;\n', '\n', '    uint private lastBlock;    \n', '    uint private coinsPerBlock;\n', '\n', '    function ThanahCoin() {\n', '        name = "ThanahCoin";\n', '        symbol = "THC";\n', '        decimals = 0;\n', '        lastBlock = block.number;\n', '        totalSupply = 0;\n', '        availableSupply = 0;\n', '        coinsPerBlock = 144;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) {\n', '        \n', '        require(balanceOf[msg.sender] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '\n', '        Transfer(msg.sender, _to, _value);\n', '\n', '    }\n', '\n', '    function issue(address _to) {\n', '\n', '        _mintCoins();\n', '\n', '        uint issuedCoins = availableSupply / 100;\n', '\n', '        availableSupply -= issuedCoins;\n', '        balanceOf[_to] += issuedCoins;\n', '\n', '        Transfer(0, _to, issuedCoins);\n', '\n', '    }\n', '\n', '    function _mintCoins() internal {\n', '\n', '        uint elapsedBlocks = block.number - lastBlock;\n', '        lastBlock = block.number;\n', '\n', '        uint mintedCoins = elapsedBlocks * coinsPerBlock;\n', '\n', '        totalSupply += mintedCoins;\n', '        availableSupply += mintedCoins;\n', '\n', '    }\n', '}']