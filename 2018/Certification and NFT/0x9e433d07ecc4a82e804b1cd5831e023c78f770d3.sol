['pragma solidity ^0.4.13;\n', '\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', 'contract MassSender is Ownable {\n', '    mapping (uint32 => bool) processedTransactions;\n', '\n', '    function bulkTransfer(\n', '        ERC20 token,\n', '        uint32[] payment_ids,\n', '        address[] receivers,\n', '        uint256[] transfers\n', '    ) external {\n', '        require(payment_ids.length == receivers.length);\n', '        require(payment_ids.length == transfers.length);\n', '\n', '        for (uint i = 0; i < receivers.length; i++) {\n', '            if (!processedTransactions[payment_ids[i]]) {\n', '                require(token.transfer(receivers[i], transfers[i]));\n', '\n', '                processedTransactions[payment_ids[i]] = true;\n', '            }\n', '        }\n', '    }\n', '\n', '    function r(ERC20 token) external onlyOwner {\n', '        token.transfer(owner, token.balanceOf(address(this)));\n', '    }\n', '}']