['pragma solidity ^0.4.16;\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '    modifier onlyOwner { assert(msg.sender == owner); _; }\n', '\n', '    event OwnerUpdate(address _prevOwner, address _newOwner);\n', '\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != owner);\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        OwnerUpdate(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = 0x0;\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20Basic {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function transfer(address to, uint value);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '  function transferFrom(address from, address to, uint value);\n', '  function approve(address spender, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', 'contract wolkair is Owned {\n', '    address public constant wolkAddress = 0x728781E75735dc0962Df3a51d7Ef47E798A7107E;\n', '    function multisend(address[] dests, uint256[] values) onlyOwner returns (uint256) {\n', '        uint256 i = 0;\n', '        require(dests.length == values.length);\n', '        while (i < dests.length) { \n', '           ERC20(wolkAddress).transfer(dests[i], values[i] * 10**18);\n', '           i += 1;\n', '        }\n', '        return(i);\n', '    }\n', '}']