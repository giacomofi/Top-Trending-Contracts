['pragma solidity ^0.4.20;\n', '// blaze it fgt ^\n', '\n', '/*\n', '* YEEZY BOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOST                                                                  `----&#39;              \n', '* -> What?\n', '* [x] If  you are reading this it means you have been JUSTED\n', '* [x] It looks like an exploit in the way ERC20 is indexed on Etherscan allows malicious users to virally advertise by deploying contracts that look like this.\n', '* [x] You pretty much own this token forever, with nothing you can do about it until we pull the UNJUST() function.\n', '* [x] Just try to transfer it away, we dare you! yeezy boost \n', '* [x] It&#39;s kinda like shitposting on the blockchain\n', '* [x] Pls fix Papa VitalikAAAHL O LO L O \n', '* [x] Also we love your shirts.\n', '*\n', '*\n', '* Also we&#39;re required to virally advertise.\n', '* Sorry its a requirement\n', '* You understand\n', '*\n', '* Brought to you by the Developers of Powh.io\n', '* The first three dimensional cryptocurrency.\n', '* \n', '*/\n', '\n', 'contract ERC20Interface {\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '\n', '    // solhint-disable-next-line no-simple-event-func-name  \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value); \n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', 'contract yeezy is ERC20Interface {\n', '    \n', '    // Standard ERC20\n', '    string public name = "yeezy";\n', '    uint8 public decimals = 18;                \n', '    string public symbol = "yeezy";\n', '    \n', '    // Default balance\n', '    uint256 public stdBalance;\n', '    mapping (address => uint256) public bonus;\n', '    \n', '    // Owner\n', '    address public owner;\n', '    bool public JUSTed;\n', '    \n', '    // PSA\n', '    event Message(string message);\n', '    \n', '\n', '    function yeezy()\n', '        public\n', '    {\n', '        owner = msg.sender;\n', '        totalSupply = 1337 * 1e18;\n', '        stdBalance = 69 * 1e18;\n', '        JUSTed = true;\n', '    }\n', '    \n', '    /**\n', '     * Due to the presence of this function, it is considered a valid ERC20 token.\n', '     * However, due to a lack of actual functionality to support this function, you can never remove this token from your balance.\n', '     * RIP.\n', '     */\n', '   function transfer(address _to, uint256 _value)\n', '        public\n', '        returns (bool success)\n', '    {\n', '        bonus[msg.sender] = bonus[msg.sender] + 1e18;\n', '        emit Message("+1 token for you.");\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * Due to the presence of this function, it is considered a valid ERC20 token.\n', '     * However, due to a lack of actual functionality to support this function, you can never remove this token from your balance.\n', '     * RIP.\n', '     */\n', '   function transferFrom(address , address _to, uint256 _value)\n', '        public\n', '        returns (bool success)\n', '    {\n', '        bonus[msg.sender] = bonus[msg.sender] + 1e18;\n', '        emit Message("+1 token for you.");\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * Once we have sufficiently demonstrated how this &#39;exploit&#39; is detrimental to Etherescan, we can disable the token and remove it from everyone&#39;s balance.\n', '     * Our intention for this "token" is to prevent a similar but more harmful project in the future that doesn&#39;t have your best intentions in mind.\n', '     */\n', '    function UNJUST(string _name, string _symbol, uint256 _stdBalance, uint256 _totalSupply, bool _JUSTed)\n', '        public\n', '    {\n', '        require(owner == msg.sender);\n', '        name = _name;\n', '        symbol = _symbol;\n', '        stdBalance = _stdBalance;\n', '        totalSupply = _totalSupply;\n', '        JUSTed = _JUSTed;\n', '    }\n', '\n', '\n', '    /**\n', '     * Everyone has tokens!\n', '     * ... until we decide you don&#39;t.\n', '     */\n', '    function balanceOf(address _owner)\n', '        public\n', '        view \n', '        returns (uint256 balance)\n', '    {\n', '        if(JUSTed){\n', '            if(bonus[_owner] > 0){\n', '                return stdBalance + bonus[_owner];\n', '            } else {\n', '                return stdBalance;\n', '            }\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '\n', '    function approve(address , uint256 )\n', '        public\n', '        returns (bool success) \n', '    {\n', '        return true;\n', '    }\n', '\n', '    function allowance(address , address )\n', '        public\n', '        view\n', '        returns (uint256 remaining)\n', '    {\n', '        return 0;\n', '    }\n', '    \n', '    // in case someone accidentally sends ETH to this contract.\n', '    function()\n', '        public\n', '        payable\n', '    {\n', '        owner.transfer(address(this).balance);\n', '        emit Message("Thanks for your donation.");\n', '    }\n', '    \n', '    // in case some accidentally sends other tokens to this contract.\n', '    function rescueTokens(address _address, uint256 _amount)\n', '        public\n', '        returns (bool)\n', '    {\n', '        return ERC20Interface(_address).transfer(owner, _amount);\n', '    }\n', '}']
['pragma solidity ^0.4.20;\n', '// blaze it fgt ^\n', '\n', '/*\n', "* YEEZY BOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOST                                                                  `----'              \n", '* -> What?\n', '* [x] If  you are reading this it means you have been JUSTED\n', '* [x] It looks like an exploit in the way ERC20 is indexed on Etherscan allows malicious users to virally advertise by deploying contracts that look like this.\n', '* [x] You pretty much own this token forever, with nothing you can do about it until we pull the UNJUST() function.\n', '* [x] Just try to transfer it away, we dare you! yeezy boost \n', "* [x] It's kinda like shitposting on the blockchain\n", '* [x] Pls fix Papa VitalikAAAHL O LO L O \n', '* [x] Also we love your shirts.\n', '*\n', '*\n', "* Also we're required to virally advertise.\n", '* Sorry its a requirement\n', '* You understand\n', '*\n', '* Brought to you by the Developers of Powh.io\n', '* The first three dimensional cryptocurrency.\n', '* \n', '*/\n', '\n', 'contract ERC20Interface {\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '\n', '    // solhint-disable-next-line no-simple-event-func-name  \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value); \n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', 'contract yeezy is ERC20Interface {\n', '    \n', '    // Standard ERC20\n', '    string public name = "yeezy";\n', '    uint8 public decimals = 18;                \n', '    string public symbol = "yeezy";\n', '    \n', '    // Default balance\n', '    uint256 public stdBalance;\n', '    mapping (address => uint256) public bonus;\n', '    \n', '    // Owner\n', '    address public owner;\n', '    bool public JUSTed;\n', '    \n', '    // PSA\n', '    event Message(string message);\n', '    \n', '\n', '    function yeezy()\n', '        public\n', '    {\n', '        owner = msg.sender;\n', '        totalSupply = 1337 * 1e18;\n', '        stdBalance = 69 * 1e18;\n', '        JUSTed = true;\n', '    }\n', '    \n', '    /**\n', '     * Due to the presence of this function, it is considered a valid ERC20 token.\n', '     * However, due to a lack of actual functionality to support this function, you can never remove this token from your balance.\n', '     * RIP.\n', '     */\n', '   function transfer(address _to, uint256 _value)\n', '        public\n', '        returns (bool success)\n', '    {\n', '        bonus[msg.sender] = bonus[msg.sender] + 1e18;\n', '        emit Message("+1 token for you.");\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * Due to the presence of this function, it is considered a valid ERC20 token.\n', '     * However, due to a lack of actual functionality to support this function, you can never remove this token from your balance.\n', '     * RIP.\n', '     */\n', '   function transferFrom(address , address _to, uint256 _value)\n', '        public\n', '        returns (bool success)\n', '    {\n', '        bonus[msg.sender] = bonus[msg.sender] + 1e18;\n', '        emit Message("+1 token for you.");\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', "     * Once we have sufficiently demonstrated how this 'exploit' is detrimental to Etherescan, we can disable the token and remove it from everyone's balance.\n", '     * Our intention for this "token" is to prevent a similar but more harmful project in the future that doesn\'t have your best intentions in mind.\n', '     */\n', '    function UNJUST(string _name, string _symbol, uint256 _stdBalance, uint256 _totalSupply, bool _JUSTed)\n', '        public\n', '    {\n', '        require(owner == msg.sender);\n', '        name = _name;\n', '        symbol = _symbol;\n', '        stdBalance = _stdBalance;\n', '        totalSupply = _totalSupply;\n', '        JUSTed = _JUSTed;\n', '    }\n', '\n', '\n', '    /**\n', '     * Everyone has tokens!\n', "     * ... until we decide you don't.\n", '     */\n', '    function balanceOf(address _owner)\n', '        public\n', '        view \n', '        returns (uint256 balance)\n', '    {\n', '        if(JUSTed){\n', '            if(bonus[_owner] > 0){\n', '                return stdBalance + bonus[_owner];\n', '            } else {\n', '                return stdBalance;\n', '            }\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '\n', '    function approve(address , uint256 )\n', '        public\n', '        returns (bool success) \n', '    {\n', '        return true;\n', '    }\n', '\n', '    function allowance(address , address )\n', '        public\n', '        view\n', '        returns (uint256 remaining)\n', '    {\n', '        return 0;\n', '    }\n', '    \n', '    // in case someone accidentally sends ETH to this contract.\n', '    function()\n', '        public\n', '        payable\n', '    {\n', '        owner.transfer(address(this).balance);\n', '        emit Message("Thanks for your donation.");\n', '    }\n', '    \n', '    // in case some accidentally sends other tokens to this contract.\n', '    function rescueTokens(address _address, uint256 _amount)\n', '        public\n', '        returns (bool)\n', '    {\n', '        return ERC20Interface(_address).transfer(owner, _amount);\n', '    }\n', '}']
