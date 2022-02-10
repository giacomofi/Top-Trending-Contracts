['pragma solidity ^0.4.24;\n', '\n', 'contract Zhoan {\n', '    \n', '    string public name;\n', '    string public symbol;\n', '    //the circulation limit of token\n', '    uint256 public totalSupply;\n', '    //decimal setting\n', '    uint8 public decimals = 18;\n', '    \n', '    //contract admin&#39;s address\n', '    address private admin_add;\n', '    //new user can get money when first register\n', '    uint private present_money=0;\n', '    \n', '    //transfer event\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    //save the msg of contract_users\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowances;\n', '    \n', '    // constructor\n', '    constructor(uint256 limit,string token_name,string token_symbol,uint8 token_decimals) public {\n', '        admin_add=msg.sender;\n', '        name=token_name;\n', '        symbol=token_symbol;\n', '        totalSupply=limit * 10 ** uint256(decimals);\n', '        decimals=token_decimals;\n', '        \n', '        balanceOf[admin_add]=totalSupply;\n', '    }\n', '    \n', '    //for admin user to change present_money\n', '    function setPresentMoney (uint money) public{\n', '        address opt_user=msg.sender;\n', '        if(opt_user == admin_add){\n', '            present_money = money;\n', '        }\n', '    }\n', '    \n', '    //add new user to contract\n', '    function approve(address _spender, uint256 value) public returns (bool success){\n', '        allowances[msg.sender][_spender] = value;\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining){\n', '        return allowances[_owner][_spender];\n', '    }\n', '    \n', '    //admin account transfer money to users\n', '    function adminSendMoneyToUser(address to,uint256 value) public{\n', '        address opt_add=msg.sender;\n', '        if(opt_add == admin_add){\n', '            transferFrom(admin_add,to,value);\n', '        }\n', '    }\n', '    \n', '    //burn account hold money\n', '    function burnAccountMoeny(address add,uint256 value) public{\n', '        address opt_add=msg.sender;\n', '        require(opt_add == admin_add);\n', '        require(balanceOf[add]>value);\n', '        \n', '        balanceOf[add]-=value;\n', '        totalSupply -=value;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success){\n', '        transferFrom(msg.sender,_to,_value);\n', '        return true;\n', '    }\n', '\n', '    //transfer action between users\n', '    function transferFrom(address from,address to,uint256 value) public returns (bool success){\n', '        \n', '        require(value <= allowances[from][msg.sender]);     // Check allowance\n', '        allowances[from][msg.sender] -= value;\n', '        //sure target no be 0x0\n', '        require(to != 0x0);\n', '        //check balance of sender\n', '        require(balanceOf[from] >= value);\n', '        //sure the amount of the transfer is greater than 0\n', '        require(balanceOf[to] + value >= balanceOf[to]);\n', '        \n', '        uint previousBalances = balanceOf[from] + balanceOf[to];\n', '        balanceOf[from] -= value;\n', '        balanceOf[to] += value;\n', '        \n', '        emit Transfer(from,to,value);\n', '        \n', '        assert(balanceOf[from] + balanceOf[to] == previousBalances);\n', '        return true;\n', '    }\n', '    \n', '    //view balance\n', '    function balanceOf(address _owner) public view returns(uint256 balance){\n', '        return balanceOf[_owner];\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'contract Zhoan {\n', '    \n', '    string public name;\n', '    string public symbol;\n', '    //the circulation limit of token\n', '    uint256 public totalSupply;\n', '    //decimal setting\n', '    uint8 public decimals = 18;\n', '    \n', "    //contract admin's address\n", '    address private admin_add;\n', '    //new user can get money when first register\n', '    uint private present_money=0;\n', '    \n', '    //transfer event\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    //save the msg of contract_users\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowances;\n', '    \n', '    // constructor\n', '    constructor(uint256 limit,string token_name,string token_symbol,uint8 token_decimals) public {\n', '        admin_add=msg.sender;\n', '        name=token_name;\n', '        symbol=token_symbol;\n', '        totalSupply=limit * 10 ** uint256(decimals);\n', '        decimals=token_decimals;\n', '        \n', '        balanceOf[admin_add]=totalSupply;\n', '    }\n', '    \n', '    //for admin user to change present_money\n', '    function setPresentMoney (uint money) public{\n', '        address opt_user=msg.sender;\n', '        if(opt_user == admin_add){\n', '            present_money = money;\n', '        }\n', '    }\n', '    \n', '    //add new user to contract\n', '    function approve(address _spender, uint256 value) public returns (bool success){\n', '        allowances[msg.sender][_spender] = value;\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining){\n', '        return allowances[_owner][_spender];\n', '    }\n', '    \n', '    //admin account transfer money to users\n', '    function adminSendMoneyToUser(address to,uint256 value) public{\n', '        address opt_add=msg.sender;\n', '        if(opt_add == admin_add){\n', '            transferFrom(admin_add,to,value);\n', '        }\n', '    }\n', '    \n', '    //burn account hold money\n', '    function burnAccountMoeny(address add,uint256 value) public{\n', '        address opt_add=msg.sender;\n', '        require(opt_add == admin_add);\n', '        require(balanceOf[add]>value);\n', '        \n', '        balanceOf[add]-=value;\n', '        totalSupply -=value;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success){\n', '        transferFrom(msg.sender,_to,_value);\n', '        return true;\n', '    }\n', '\n', '    //transfer action between users\n', '    function transferFrom(address from,address to,uint256 value) public returns (bool success){\n', '        \n', '        require(value <= allowances[from][msg.sender]);     // Check allowance\n', '        allowances[from][msg.sender] -= value;\n', '        //sure target no be 0x0\n', '        require(to != 0x0);\n', '        //check balance of sender\n', '        require(balanceOf[from] >= value);\n', '        //sure the amount of the transfer is greater than 0\n', '        require(balanceOf[to] + value >= balanceOf[to]);\n', '        \n', '        uint previousBalances = balanceOf[from] + balanceOf[to];\n', '        balanceOf[from] -= value;\n', '        balanceOf[to] += value;\n', '        \n', '        emit Transfer(from,to,value);\n', '        \n', '        assert(balanceOf[from] + balanceOf[to] == previousBalances);\n', '        return true;\n', '    }\n', '    \n', '    //view balance\n', '    function balanceOf(address _owner) public view returns(uint256 balance){\n', '        return balanceOf[_owner];\n', '    }\n', '\n', '}']