['pragma solidity ^0.4.18;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract BAI is owned {\n', '    string public constant name = "BAI";\n', '    string public constant symbol = "BAI";\n', '    uint256 private constant _INITIAL_SUPPLY = 21000000000;\n', '    uint8 public decimals = 0;\n', '\n', '    uint256 public totalSupply;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    function BAI (\n', '        address genesis\n', '    ) public {\n', '        owner = msg.sender;\n', '        require(owner != 0x0);\n', '        require(genesis != 0x0);\n', '        totalSupply = _INITIAL_SUPPLY;\n', '        balanceOf[genesis] = totalSupply;\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != 0x0);\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function destroy() public {\n', '        if (msg.sender == owner) {\n', '            selfdestruct(owner);\n', '        }\n', '    }\n', '}']