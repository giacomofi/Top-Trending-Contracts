['pragma solidity ^0.4.18;\n', '\n', '// ----------------------------------------------------------------------------------------------\n', '// docoin by DO Limited.\n', '// An ERC20 standard\n', '//\n', '// author: docoin Team\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint256 _totalSupply);\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract DO is ERC20Interface {\n', '    uint256 public constant decimals = 8;\n', '\n', '    string public constant symbol = "DO";\n', '    string public constant name = "docoin";\n', '\n', '    uint256 public _totalSupply = 10 ** 19; \n', '\n', '    // Owner of this contract\n', '    address public owner;\n', '\n', '    // Balances DO for each account\n', '    mapping(address => uint256) private balances;\n', '\n', '    // Owner of account approves the transfer of an amount to another account\n', '    mapping(address => mapping (address => uint256)) private allowed;\n', '\n', '    // List of approved investors\n', '    mapping(address => bool) private approvedInvestorList;\n', '\n', '    // deposit\n', '    mapping(address => uint256) private deposit;\n', '\n', '\n', '    // totalTokenSold\n', '    uint256 public totalTokenSold = 0;\n', '\n', '\n', '    /**\n', '     * @dev Fix for the ERC20 short address attack.\n', '     */\n', '    modifier onlyPayloadSize(uint size) {\n', '      if(msg.data.length < size + 4) {\n', '        revert();\n', '      }\n', '      _;\n', '    }\n', '\n', '\n', '    /// @dev Constructor\n', '    function DO()\n', '        public {\n', '        owner = msg.sender;\n', '        balances[owner] = _totalSupply;\n', '    }\n', '\n', '    /// @dev Gets totalSupply\n', '    /// @return Total supply\n', '    function totalSupply()\n', '        public\n', '        constant\n', '        returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '\n', '    /// @dev Gets account&#39;s balance\n', '    /// @param _addr Address of the account\n', '    /// @return Account balance\n', '    function balanceOf(address _addr)\n', '        public\n', '        constant\n', '        returns (uint256) {\n', '        return balances[_addr];\n', '    }\n', '\n', '    /// @dev check address is approved investor\n', '    /// @param _addr address\n', '    function isApprovedInvestor(address _addr)\n', '        public\n', '        constant\n', '        returns (bool) {\n', '        return approvedInvestorList[_addr];\n', '    }\n', '\n', '    /// @dev get ETH deposit\n', '    /// @param _addr address get deposit\n', '    /// @return amount deposit of an buyer\n', '    function getDeposit(address _addr)\n', '        public\n', '        constant\n', '        returns(uint256){\n', '        return deposit[_addr];\n', '\t}\n', '\n', '\n', '    /// @dev Transfers the balance from msg.sender to an account\n', '    /// @param _to Recipient address\n', '    /// @param _amount Transfered amount in unit\n', '    /// @return Transfer status\n', '    function transfer(address _to, uint256 _amount)\n', '        public\n', '\n', '        returns (bool) {\n', '        // if sender&#39;s balance has enough unit and amount >= 0,\n', '        //      and the sum is not overflow,\n', '        // then DO transfer\n', '        if ( (balances[msg.sender] >= _amount) &&\n', '             (_amount >= 0) &&\n', '             (balances[_to] + _amount > balances[_to]) ) {\n', '\n', '            balances[msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '            Transfer(msg.sender, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    // Send _value amount of tokens from address _from to address _to\n', '    // The transferFrom method is used for a withdraw workflow, allowing contracts to send\n', '    // tokens on your behalf, for example to "deposit" to a contract address and/or to charge\n', '    // fees in sub-currencies; the command should fail unless the _from account has\n', '    // deliberately authorized the sender of the message via some mechanism; we propose\n', '    // these standardized APIs for approval:\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amount\n', '    )\n', '    public\n', '\n', '    returns (bool success) {\n', '        if (balances[_from] >= _amount && _amount > 0 && allowed[_from][msg.sender] >= _amount) {\n', '            balances[_from] -= _amount;\n', '            allowed[_from][msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '            Transfer(_from, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '    // If this function is called again it overwrites the current allowance with _value.\n', '    function approve(address _spender, uint256 _amount)\n', '        public\n', '\n', '        returns (bool success) {\n', '        require((_amount == 0) || (allowed[msg.sender][_spender] == 0));\n', '        allowed[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '    // get allowance\n', '    function allowance(address _owner, address _spender)\n', '        public\n', '        constant\n', '        returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function () public payable{\n', '        revert();\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '// ----------------------------------------------------------------------------------------------\n', '// docoin by DO Limited.\n', '// An ERC20 standard\n', '//\n', '// author: docoin Team\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint256 _totalSupply);\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract DO is ERC20Interface {\n', '    uint256 public constant decimals = 8;\n', '\n', '    string public constant symbol = "DO";\n', '    string public constant name = "docoin";\n', '\n', '    uint256 public _totalSupply = 10 ** 19; \n', '\n', '    // Owner of this contract\n', '    address public owner;\n', '\n', '    // Balances DO for each account\n', '    mapping(address => uint256) private balances;\n', '\n', '    // Owner of account approves the transfer of an amount to another account\n', '    mapping(address => mapping (address => uint256)) private allowed;\n', '\n', '    // List of approved investors\n', '    mapping(address => bool) private approvedInvestorList;\n', '\n', '    // deposit\n', '    mapping(address => uint256) private deposit;\n', '\n', '\n', '    // totalTokenSold\n', '    uint256 public totalTokenSold = 0;\n', '\n', '\n', '    /**\n', '     * @dev Fix for the ERC20 short address attack.\n', '     */\n', '    modifier onlyPayloadSize(uint size) {\n', '      if(msg.data.length < size + 4) {\n', '        revert();\n', '      }\n', '      _;\n', '    }\n', '\n', '\n', '    /// @dev Constructor\n', '    function DO()\n', '        public {\n', '        owner = msg.sender;\n', '        balances[owner] = _totalSupply;\n', '    }\n', '\n', '    /// @dev Gets totalSupply\n', '    /// @return Total supply\n', '    function totalSupply()\n', '        public\n', '        constant\n', '        returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '\n', "    /// @dev Gets account's balance\n", '    /// @param _addr Address of the account\n', '    /// @return Account balance\n', '    function balanceOf(address _addr)\n', '        public\n', '        constant\n', '        returns (uint256) {\n', '        return balances[_addr];\n', '    }\n', '\n', '    /// @dev check address is approved investor\n', '    /// @param _addr address\n', '    function isApprovedInvestor(address _addr)\n', '        public\n', '        constant\n', '        returns (bool) {\n', '        return approvedInvestorList[_addr];\n', '    }\n', '\n', '    /// @dev get ETH deposit\n', '    /// @param _addr address get deposit\n', '    /// @return amount deposit of an buyer\n', '    function getDeposit(address _addr)\n', '        public\n', '        constant\n', '        returns(uint256){\n', '        return deposit[_addr];\n', '\t}\n', '\n', '\n', '    /// @dev Transfers the balance from msg.sender to an account\n', '    /// @param _to Recipient address\n', '    /// @param _amount Transfered amount in unit\n', '    /// @return Transfer status\n', '    function transfer(address _to, uint256 _amount)\n', '        public\n', '\n', '        returns (bool) {\n', "        // if sender's balance has enough unit and amount >= 0,\n", '        //      and the sum is not overflow,\n', '        // then DO transfer\n', '        if ( (balances[msg.sender] >= _amount) &&\n', '             (_amount >= 0) &&\n', '             (balances[_to] + _amount > balances[_to]) ) {\n', '\n', '            balances[msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '            Transfer(msg.sender, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    // Send _value amount of tokens from address _from to address _to\n', '    // The transferFrom method is used for a withdraw workflow, allowing contracts to send\n', '    // tokens on your behalf, for example to "deposit" to a contract address and/or to charge\n', '    // fees in sub-currencies; the command should fail unless the _from account has\n', '    // deliberately authorized the sender of the message via some mechanism; we propose\n', '    // these standardized APIs for approval:\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amount\n', '    )\n', '    public\n', '\n', '    returns (bool success) {\n', '        if (balances[_from] >= _amount && _amount > 0 && allowed[_from][msg.sender] >= _amount) {\n', '            balances[_from] -= _amount;\n', '            allowed[_from][msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '            Transfer(_from, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '    // If this function is called again it overwrites the current allowance with _value.\n', '    function approve(address _spender, uint256 _amount)\n', '        public\n', '\n', '        returns (bool success) {\n', '        require((_amount == 0) || (allowed[msg.sender][_spender] == 0));\n', '        allowed[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '    // get allowance\n', '    function allowance(address _owner, address _spender)\n', '        public\n', '        constant\n', '        returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function () public payable{\n', '        revert();\n', '    }\n', '\n', '}']
