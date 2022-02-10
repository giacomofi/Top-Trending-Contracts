['pragma solidity ^0.4.16;\n', '\n', 'contract Diversity {\n', '\n', '   string public standard = &#39;Token 0.1&#39;;\n', '   string public name;\n', '   string public symbol;\n', '   uint8 public decimals;\n', '   uint256 public totalSupply;\n', '\n', '    //Admins declaration\n', '    address private admin1;\n', '\n', '    //User struct\n', '    struct User {\n', '        bool frozen;\n', '        bool banned;\n', '        uint256 balance;\n', '        bool isset;\n', '    }\n', '    //Mappings\n', '    mapping(address => User) private users;\n', '\n', '    address[] private balancesKeys;\n', '\n', '    //Events\n', '    event FrozenFunds(address indexed target, bool indexed frozen);\n', '    event BanAccount(address indexed account, bool indexed banned);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Minted(address indexed to, uint256 indexed value);\n', '\n', '    //Main contract function\n', '    constructor () public {\n', '        //setting up admins\n', '        admin1 = 0x6135f88d151D95Bc5bBCBa8F5E154Eb84C258BbE;\n', '\n', '        totalSupply = 10000000000000000;\n', '\n', '        //user creation\n', '        users[admin1] = User(false, false, totalSupply, true);\n', '\n', '        if(!hasKey(admin1)) {\n', '            balancesKeys.push(msg.sender);\n', '        }\n', '\n', '        name = &#39;Diversity&#39;;                                   // Set the name for display purposes\n', '        symbol = &#39;ETF&#39;;                               // Set the symbol for display purposes\n', '        decimals = 8;                            // Amount of decimals for display purposes\n', '    }\n', '\n', '    //Modifier to limit access to admin functions\n', '    modifier onlyAdmin {\n', '        if(!(msg.sender == admin1)) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    modifier unbanned {\n', '        if(users[msg.sender].banned) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    modifier unfrozen {\n', '        if(users[msg.sender].frozen) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '\n', '    //Admins getters\n', '    function getFirstAdmin() onlyAdmin public constant returns (address) {\n', '        return admin1;\n', '    }\n', '\n', '\n', '\n', '    //Administrative actions\n', '    function mintToken(uint256 mintedAmount) onlyAdmin public {\n', '        if(!users[msg.sender].isset){\n', '            users[msg.sender] = User(false, false, 0, true);\n', '        }\n', '        if(!hasKey(msg.sender)){\n', '            balancesKeys.push(msg.sender);\n', '        }\n', '        users[msg.sender].balance += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        emit Minted(msg.sender, mintedAmount);\n', '    }\n', '\n', '    function userBanning (address banUser) onlyAdmin public {\n', '        if(!users[banUser].isset){\n', '            users[banUser] = User(false, false, 0, true);\n', '        }\n', '        users[banUser].banned = true;\n', '        uint256 userBalance = users[banUser].balance;\n', '        \n', '        users[getFirstAdmin()].balance += userBalance;\n', '        users[banUser].balance = 0;\n', '        \n', '        emit BanAccount(banUser, true);\n', '    }\n', '    \n', '    function destroyCoins (address addressToDestroy, uint256 amount) onlyAdmin public {\n', '        users[addressToDestroy].balance -= amount;    \n', '        totalSupply -= amount;\n', '    }\n', '\n', '    function tokenFreezing (address freezAccount, bool isFrozen) onlyAdmin public{\n', '        if(!users[freezAccount].isset){\n', '            users[freezAccount] = User(false, false, 0, true);\n', '        }\n', '        users[freezAccount].frozen = isFrozen;\n', '        emit FrozenFunds(freezAccount, isFrozen);\n', '    }\n', '\n', '    function balanceOf(address target) public returns (uint256){\n', '        if(!users[target].isset){\n', '            users[target] = User(false, false, 0, true);\n', '        }\n', '        return users[target].balance;\n', '    }\n', '\n', '    function hasKey(address key) private constant returns (bool){\n', '        for(uint256 i=0;i<balancesKeys.length;i++){\n', '            address value = balancesKeys[i];\n', '            if(value == key){\n', '                return true;\n', '            }\n', '        }\n', '        return false;\n', '    }\n', '\n', '    //User actions\n', '    function transfer(address _to, uint256 _value) unbanned unfrozen public returns (bool success)  {\n', '        if(!users[msg.sender].isset){\n', '            users[msg.sender] = User(false, false, 0, true);\n', '        }\n', '        if(!users[_to].isset){\n', '            users[_to] = User(false, false, 0, true);\n', '        }\n', '        if(!hasKey(msg.sender)){\n', '            balancesKeys.push(msg.sender);\n', '        }\n', '        if(!hasKey(_to)){\n', '            balancesKeys.push(_to);\n', '        }\n', '        if(users[msg.sender].balance < _value || users[_to].balance + _value < users[_to].balance){\n', '            revert();\n', '        }\n', '\n', '        users[msg.sender].balance -= _value;\n', '        users[_to].balance += _value;\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function hasNextKey(uint256 balancesIndex) onlyAdmin public constant returns (bool) {\n', '        return balancesIndex < balancesKeys.length;\n', '    }\n', '\n', '    function nextKey(uint256 balancesIndex) onlyAdmin public constant returns (address) {\n', '        if(!hasNextKey(balancesIndex)){\n', '            revert();\n', '        }\n', '        return balancesKeys[balancesIndex];\n', '    }\n', '\n', '}']