['pragma solidity 0.4.25;\n', '\n', 'contract StandardToken {\n', '\n', '    /* Data structures */\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '\n', '    /* Events */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    /* Read and write storage functions */\n', '\n', '    // Transfers sender&#39;s tokens to a given address. Returns success.\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            emit Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    // Allows allowed third party to transfer tokens from one address to another. Returns success. _value Number of tokens to transfer.\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            emit Transfer(_from, _to, _value);\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    // Returns number of tokens owned by given address.\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    // Sets approved amount of tokens for spender. Returns success. _value Number of approved tokens.\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /* Read storage functions */\n', '\n', '    //Returns number of allowed tokens for given address. _owner Address of token owner. _spender Address of token spender.\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', 'contract AltTokenFund is StandardToken {\n', '\n', '    /* External contracts */\n', '\n', '    address public emissionContractAddress = 0x0;\n', '\n', '    //Token meta data\n', '    string constant public name = "Alt Token Fund";\n', '    string constant public symbol = "ATF";\n', '    uint8 constant public decimals = 8;\n', '\n', '    /* Storage */\n', '    address public owner = 0x0;\n', '    bool public emissionEnabled = true;\n', '    bool transfersEnabled = true;\n', '\n', '    /* Modifiers */\n', '\n', '    modifier isCrowdfundingContract() {\n', '        // Only emission address to do this action\n', '        if (msg.sender != emissionContractAddress) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        // Only owner is allowed to do this action.\n', '        if (msg.sender != owner) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    /* Contract functions */\n', '\n', '    // TokenFund emission function. _for is Address of receiver, tokenCount is Number of tokens to issue.\n', '    function issueTokens(address _for, uint tokenCount)\n', '        external\n', '        isCrowdfundingContract\n', '        returns (bool)\n', '    {\n', '        if (emissionEnabled == false) {\n', '            revert();\n', '        }\n', '\n', '        balances[_for] += tokenCount;\n', '        totalSupply += tokenCount;\n', '        return true;\n', '    }\n', '\n', '    // Withdraws tokens for msg.sender.\n', '    function withdrawTokens(uint tokenCount)\n', '        public\n', '        returns (bool)\n', '    {\n', '        uint balance = balances[msg.sender];\n', '        if (balance < tokenCount) {\n', '            return false;\n', '        }\n', '        balances[msg.sender] -= tokenCount;\n', '        totalSupply -= tokenCount;\n', '        return true;\n', '    }\n', '\n', '    // Function to change address that is allowed to do emission.\n', '    function changeEmissionContractAddress(address newAddress)\n', '        external\n', '        onlyOwner\n', '        returns (bool)\n', '    {\n', '        emissionContractAddress = newAddress;\n', '    }\n', '\n', '    // Function that enables/disables transfers of token, value is true/false\n', '    function enableTransfers(bool value)\n', '        external\n', '        onlyOwner\n', '    {\n', '        transfersEnabled = value;\n', '    }\n', '\n', '    // Function that enables/disables token emission.\n', '    function enableEmission(bool value)\n', '        external\n', '        onlyOwner\n', '    {\n', '        emissionEnabled = value;\n', '    }\n', '\n', '    /* Overriding ERC20 standard token functions to support transfer lock */\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        if (transfersEnabled == true) {\n', '            return super.transfer(_to, _value);\n', '        }\n', '        return false;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        if (transfersEnabled == true) {\n', '            return super.transferFrom(_from, _to, _value);\n', '        }\n', '        return false;\n', '    }\n', '\n', '\n', '    // Contract constructor function sets initial token balances. _owner Address of the owner of AltTokenFund.\n', '    constructor (address _owner) public\n', '    {\n', '        totalSupply = 0;\n', '        owner = _owner;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '}']
['pragma solidity 0.4.25;\n', '\n', 'contract StandardToken {\n', '\n', '    /* Data structures */\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '\n', '    /* Events */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    /* Read and write storage functions */\n', '\n', "    // Transfers sender's tokens to a given address. Returns success.\n", '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            emit Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    // Allows allowed third party to transfer tokens from one address to another. Returns success. _value Number of tokens to transfer.\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            emit Transfer(_from, _to, _value);\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    // Returns number of tokens owned by given address.\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    // Sets approved amount of tokens for spender. Returns success. _value Number of approved tokens.\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /* Read storage functions */\n', '\n', '    //Returns number of allowed tokens for given address. _owner Address of token owner. _spender Address of token spender.\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', 'contract AltTokenFund is StandardToken {\n', '\n', '    /* External contracts */\n', '\n', '    address public emissionContractAddress = 0x0;\n', '\n', '    //Token meta data\n', '    string constant public name = "Alt Token Fund";\n', '    string constant public symbol = "ATF";\n', '    uint8 constant public decimals = 8;\n', '\n', '    /* Storage */\n', '    address public owner = 0x0;\n', '    bool public emissionEnabled = true;\n', '    bool transfersEnabled = true;\n', '\n', '    /* Modifiers */\n', '\n', '    modifier isCrowdfundingContract() {\n', '        // Only emission address to do this action\n', '        if (msg.sender != emissionContractAddress) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        // Only owner is allowed to do this action.\n', '        if (msg.sender != owner) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    /* Contract functions */\n', '\n', '    // TokenFund emission function. _for is Address of receiver, tokenCount is Number of tokens to issue.\n', '    function issueTokens(address _for, uint tokenCount)\n', '        external\n', '        isCrowdfundingContract\n', '        returns (bool)\n', '    {\n', '        if (emissionEnabled == false) {\n', '            revert();\n', '        }\n', '\n', '        balances[_for] += tokenCount;\n', '        totalSupply += tokenCount;\n', '        return true;\n', '    }\n', '\n', '    // Withdraws tokens for msg.sender.\n', '    function withdrawTokens(uint tokenCount)\n', '        public\n', '        returns (bool)\n', '    {\n', '        uint balance = balances[msg.sender];\n', '        if (balance < tokenCount) {\n', '            return false;\n', '        }\n', '        balances[msg.sender] -= tokenCount;\n', '        totalSupply -= tokenCount;\n', '        return true;\n', '    }\n', '\n', '    // Function to change address that is allowed to do emission.\n', '    function changeEmissionContractAddress(address newAddress)\n', '        external\n', '        onlyOwner\n', '        returns (bool)\n', '    {\n', '        emissionContractAddress = newAddress;\n', '    }\n', '\n', '    // Function that enables/disables transfers of token, value is true/false\n', '    function enableTransfers(bool value)\n', '        external\n', '        onlyOwner\n', '    {\n', '        transfersEnabled = value;\n', '    }\n', '\n', '    // Function that enables/disables token emission.\n', '    function enableEmission(bool value)\n', '        external\n', '        onlyOwner\n', '    {\n', '        emissionEnabled = value;\n', '    }\n', '\n', '    /* Overriding ERC20 standard token functions to support transfer lock */\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        if (transfersEnabled == true) {\n', '            return super.transfer(_to, _value);\n', '        }\n', '        return false;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        if (transfersEnabled == true) {\n', '            return super.transferFrom(_from, _to, _value);\n', '        }\n', '        return false;\n', '    }\n', '\n', '\n', '    // Contract constructor function sets initial token balances. _owner Address of the owner of AltTokenFund.\n', '    constructor (address _owner) public\n', '    {\n', '        totalSupply = 0;\n', '        owner = _owner;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '}']