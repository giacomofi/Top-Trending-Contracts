['pragma solidity ^0.4.24;\n', '\n', 'contract Zhoan {\n', '    string public token_name;\n', '    \n', '    //contract admin&#39;s address\n', '    address private admin_add;\n', '    //decimal setting\n', '    uint8 private decimals = 18;\n', '    //new user can get money when first register\n', '    uint private present_money=0;\n', '    //the circulation limit of token\n', '    uint256 private max_circulation;\n', '    \n', '    //transfer event\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    //save the msg of contract_users\n', '    mapping(address => uint) public contract_users;\n', '    \n', '    // constructor\n', '    constructor(uint limit,string symbol) public {\n', '        admin_add=msg.sender;\n', '        max_circulation=limit * 10 ** uint256(decimals);\n', '        contract_users[admin_add]=max_circulation;\n', '        token_name = symbol;\n', '    }\n', '    \n', '    //for admin user to change present_money\n', '    function setPresentMoney (uint money) public{\n', '        address opt_user=msg.sender;\n', '        if(opt_user == admin_add){\n', '            present_money = money;\n', '        }\n', '    }\n', '    \n', '    //add new user to contract\n', '    function addNewUser(address newUser) public{\n', '        address opt_user=msg.sender;\n', '        if(opt_user == admin_add){\n', '            transfer_opt(admin_add,newUser,present_money);\n', '        }\n', '    }\n', '    \n', '    //transfer action between users\n', '    function userTransfer(address from,address to,uint256 value) public{\n', '        transfer_opt(from,to,value);\n', '    }\n', '    \n', '    //admin account transfer money to users\n', '    function adminSendMoneyToUser(address to,uint256 value) public{\n', '        address opt_add=msg.sender;\n', '        if(opt_add == admin_add){\n', '            transfer_opt(admin_add,to,value);\n', '        }\n', '    }\n', '    \n', '    //burn account hold money\n', '    function burnAccountMoeny(address add,uint256 value) public{\n', '        address opt_add=msg.sender;\n', '        require(opt_add == admin_add);\n', '        require(contract_users[add]>value);\n', '        \n', '        contract_users[add]-=value;\n', '        max_circulation -=value;\n', '    }\n', '\n', '    //util for excute transfer action\n', '    function transfer_opt(address from,address to,uint value) private{\n', '        //sure target no be 0x0\n', '        require(to != 0x0);\n', '        //check balance of sender\n', '        require(contract_users[from] >= value);\n', '        //sure the amount of the transfer is greater than 0\n', '        require(contract_users[to] + value >= contract_users[to]);\n', '        \n', '        uint previousBalances = contract_users[from] + contract_users[to];\n', '        contract_users[from] -= value;\n', '        contract_users[to] += value;\n', '        \n', '        emit Transfer(from,to,value);\n', '        \n', '        assert(contract_users[from] + contract_users[to] == previousBalances);\n', '    }\n', '    \n', '    //view balance\n', '    function queryBalance(address add) public view returns(uint){\n', '        return contract_users[add];\n', '    }\n', '    \n', '    //view surplus\n', '    function surplus() public view returns(uint,uint){\n', '        return (contract_users[admin_add],max_circulation);\n', '    }\n', '}']