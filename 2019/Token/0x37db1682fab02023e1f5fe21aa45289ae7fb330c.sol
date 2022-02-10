['pragma solidity ^0.4.20;\n', '\n', 'contract ERC20 {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', 'contract exForward{\n', '    address public owner;\n', '    event change_owner(string newOwner, address indexed toOwner);\n', '    event eth_deposit(address sender, uint amount);\n', '    event erc_deposit(address from, address ctr, address to, uint amount);\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '    modifier isOwner{\n', '        require(owner == msg.sender);\n', '        _;\n', '    }\n', '    function trToken(address tokenContract, uint tokens) public{\n', '        ERC20(tokenContract).transferFrom(msg.sender, owner, tokens);\n', '        emit erc_deposit(msg.sender, tokenContract, owner, tokens);\n', '    }\n', '    function changeOwner(address to_owner) public isOwner returns (bool success){\n', '        owner = to_owner;\n', '        emit change_owner("OwnerChanged",to_owner);\n', '        return true;\n', '    }\n', '    function() payable public {\n', '        owner.transfer(msg.value);\n', '        emit eth_deposit(msg.sender,msg.value);\n', '    }\n', '}']