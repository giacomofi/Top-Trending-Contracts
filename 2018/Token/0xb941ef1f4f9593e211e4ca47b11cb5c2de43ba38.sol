['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function toUINT112(uint256 a) internal pure returns(uint112) {\n', '    assert(uint112(a) == a);\n', '    return uint112(a);\n', '  }\n', '\n', '  function toUINT120(uint256 a) internal pure returns(uint120) {\n', '    assert(uint120(a) == a);\n', '    return uint120(a);\n', '  }\n', '\n', '  function toUINT128(uint256 a) internal pure returns(uint128) {\n', '    assert(uint128(a) == a);\n', '    return uint128(a);\n', '  }\n', '}\n', '\n', 'contract Owned {\n', '\n', '    address public owner;\n', '\n', '    function Owned() public{\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function setOwner(address _newOwner) public onlyOwner {\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', '// Abstract contract for the full ERC 20 Token standard\n', '// https://github.com/ethereum/EIPs/issues/20\n', '\n', 'contract Token {\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    //uint256 public totalSupply;\n', '    function totalSupply()public constant returns (uint256 supply);\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner)public constant returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value)public returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value)public returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of wei to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value)public returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender)public constant returns (uint256 remaining);\n', '\n', '}\n', '\n', '\n', '/// FFC token, ERC20 compliant\n', 'contract FFC is Token, Owned {\n', '    using SafeMath for uint256;\n', '\n', '    string public constant name    = "Free Fair Chain Token";  //The Token&#39;s name\n', '    uint8 public constant decimals = 18;               //Number of decimals of the smallest unit\n', '    string public constant symbol  = "FFC";            //An identifier    \n', '\n', '    // packed to 256bit to save gas usage.\n', '    struct Supplies {\n', '        // uint128&#39;s max value is about 3e38.\n', '        // it&#39;s enough to present amount of tokens\n', '        uint128 total;\n', '    }\n', '\n', '    Supplies supplies;\n', '\n', '    // Packed to 256bit to save gas usage.    \n', '    struct Account {\n', '        // uint112&#39;s max value is about 5e33.\n', '        // it&#39;s enough to present amount of tokens\n', '        uint112 balance;\n', '        // safe to store timestamp\n', '        uint32 lastMintedTimestamp;\n', '    }\n', '\n', '    // Balances for each account\n', '    mapping(address => Account) accounts;\n', '\n', '    // Owner of account approves the transfer of an amount to another account\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '\n', '\n', '\t// \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\t\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    // Constructor\n', '    function FFC() public{\n', '    \tsupplies.total = 1 * (10 ** 10) * (10 ** 18);\n', '    }\n', '\n', '    function totalSupply()public constant returns (uint256 supply){\n', '        return supplies.total;\n', '    }\n', '\n', '    // Send back ether sent to me\n', '    function ()public {\n', '        revert();\n', '    }\n', '\n', '    // If sealed, transfer is enabled \n', '    function isSealed()public constant returns (bool) {\n', '        return owner == 0;\n', '    }\n', '    \n', '    function lastMintedTimestamp(address _owner)public constant returns(uint32) {\n', '        return accounts[_owner].lastMintedTimestamp;\n', '    }\n', '\n', '    // What is the balance of a particular account?\n', '    function balanceOf(address _owner)public constant returns (uint256 balance) {\n', '        return accounts[_owner].balance;\n', '    }\n', '\n', '    // Transfer the balance from owner&#39;s account to another account\n', '    function transfer(address _to, uint256 _amount)public returns (bool success) {\n', '        require(isSealed());\n', '\t\t\n', '        // according to FFC&#39;s total supply, never overflow here\n', '        if ( accounts[msg.sender].balance >= _amount && _amount > 0) {            \n', '            accounts[msg.sender].balance -= uint112(_amount);\n', '            accounts[_to].balance = _amount.add(accounts[_to].balance).toUINT112();\n', '            emit Transfer(msg.sender, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    // Send _value amount of tokens from address _from to address _to\n', '    // The transferFrom method is used for a withdraw workflow, allowing contracts to send\n', '    // tokens on your behalf, for example to "deposit" to a contract address and/or to charge\n', '    // fees in sub-currencies; the command should fail unless the _from account has\n', '    // deliberately authorized the sender of the message via some mechanism; we propose\n', '    // these standardized APIs for approval:\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amount\n', '    )public returns (bool success) {\n', '        require(isSealed());\n', '\n', '        // according to FFC&#39;s total supply, never overflow here\n', '        if (accounts[_from].balance >= _amount\n', '            && allowed[_from][msg.sender] >= _amount\n', '            && _amount > 0) {\n', '            accounts[_from].balance -= uint112(_amount);\n', '            allowed[_from][msg.sender] -= _amount;\n', '            accounts[_to].balance = _amount.add(accounts[_to].balance).toUINT112();\n', '            emit Transfer(_from, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '    // If this function is called again it overwrites the current allowance with _value.\n', '    function approve(address _spender, uint256 _amount)public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _amount;\n', '        emit Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '    /* Approves and then calls the receiving contract */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '\n', '        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn&#39;t have to include a contract in here just for this.\n', '        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)\n', '        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.\n', '        //if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }\n', '        ApprovalReceiver(_spender).receiveApproval(msg.sender, _value, this, _extraData);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    function mint0(address _owner, uint256 _amount)public onlyOwner {\n', '    \t\taccounts[_owner].balance = _amount.add(accounts[_owner].balance).toUINT112();\n', '\n', '        accounts[_owner].lastMintedTimestamp = uint32(block.timestamp);\n', '\n', '        //supplies.total = _amount.add(supplies.total).toUINT128();\n', '        emit Transfer(0, _owner, _amount);\n', '    }\n', '    \n', '    // Mint tokens and assign to some one\n', '    function mint(address _owner, uint256 _amount, uint32 timestamp)public onlyOwner{\n', '        accounts[_owner].balance = _amount.add(accounts[_owner].balance).toUINT112();\n', '\n', '        accounts[_owner].lastMintedTimestamp = timestamp;\n', '\n', '        supplies.total = _amount.add(supplies.total).toUINT128();\n', '        emit Transfer(0, _owner, _amount);\n', '    }\n', '\n', '    // Set owner to zero address, to disable mint, and enable token transfer\n', '    function seal()public onlyOwner {\n', '        setOwner(0);\n', '    }\n', '}\n', '\n', 'contract ApprovalReceiver {\n', '    function receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)public;\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function toUINT112(uint256 a) internal pure returns(uint112) {\n', '    assert(uint112(a) == a);\n', '    return uint112(a);\n', '  }\n', '\n', '  function toUINT120(uint256 a) internal pure returns(uint120) {\n', '    assert(uint120(a) == a);\n', '    return uint120(a);\n', '  }\n', '\n', '  function toUINT128(uint256 a) internal pure returns(uint128) {\n', '    assert(uint128(a) == a);\n', '    return uint128(a);\n', '  }\n', '}\n', '\n', 'contract Owned {\n', '\n', '    address public owner;\n', '\n', '    function Owned() public{\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function setOwner(address _newOwner) public onlyOwner {\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', '// Abstract contract for the full ERC 20 Token standard\n', '// https://github.com/ethereum/EIPs/issues/20\n', '\n', 'contract Token {\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    //uint256 public totalSupply;\n', '    function totalSupply()public constant returns (uint256 supply);\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner)public constant returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value)public returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value)public returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of wei to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value)public returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender)public constant returns (uint256 remaining);\n', '\n', '}\n', '\n', '\n', '/// FFC token, ERC20 compliant\n', 'contract FFC is Token, Owned {\n', '    using SafeMath for uint256;\n', '\n', '    string public constant name    = "Free Fair Chain Token";  //The Token\'s name\n', '    uint8 public constant decimals = 18;               //Number of decimals of the smallest unit\n', '    string public constant symbol  = "FFC";            //An identifier    \n', '\n', '    // packed to 256bit to save gas usage.\n', '    struct Supplies {\n', "        // uint128's max value is about 3e38.\n", "        // it's enough to present amount of tokens\n", '        uint128 total;\n', '    }\n', '\n', '    Supplies supplies;\n', '\n', '    // Packed to 256bit to save gas usage.    \n', '    struct Account {\n', "        // uint112's max value is about 5e33.\n", "        // it's enough to present amount of tokens\n", '        uint112 balance;\n', '        // safe to store timestamp\n', '        uint32 lastMintedTimestamp;\n', '    }\n', '\n', '    // Balances for each account\n', '    mapping(address => Account) accounts;\n', '\n', '    // Owner of account approves the transfer of an amount to another account\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '\n', '\n', '\t// \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\t\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    // Constructor\n', '    function FFC() public{\n', '    \tsupplies.total = 1 * (10 ** 10) * (10 ** 18);\n', '    }\n', '\n', '    function totalSupply()public constant returns (uint256 supply){\n', '        return supplies.total;\n', '    }\n', '\n', '    // Send back ether sent to me\n', '    function ()public {\n', '        revert();\n', '    }\n', '\n', '    // If sealed, transfer is enabled \n', '    function isSealed()public constant returns (bool) {\n', '        return owner == 0;\n', '    }\n', '    \n', '    function lastMintedTimestamp(address _owner)public constant returns(uint32) {\n', '        return accounts[_owner].lastMintedTimestamp;\n', '    }\n', '\n', '    // What is the balance of a particular account?\n', '    function balanceOf(address _owner)public constant returns (uint256 balance) {\n', '        return accounts[_owner].balance;\n', '    }\n', '\n', "    // Transfer the balance from owner's account to another account\n", '    function transfer(address _to, uint256 _amount)public returns (bool success) {\n', '        require(isSealed());\n', '\t\t\n', "        // according to FFC's total supply, never overflow here\n", '        if ( accounts[msg.sender].balance >= _amount && _amount > 0) {            \n', '            accounts[msg.sender].balance -= uint112(_amount);\n', '            accounts[_to].balance = _amount.add(accounts[_to].balance).toUINT112();\n', '            emit Transfer(msg.sender, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    // Send _value amount of tokens from address _from to address _to\n', '    // The transferFrom method is used for a withdraw workflow, allowing contracts to send\n', '    // tokens on your behalf, for example to "deposit" to a contract address and/or to charge\n', '    // fees in sub-currencies; the command should fail unless the _from account has\n', '    // deliberately authorized the sender of the message via some mechanism; we propose\n', '    // these standardized APIs for approval:\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amount\n', '    )public returns (bool success) {\n', '        require(isSealed());\n', '\n', "        // according to FFC's total supply, never overflow here\n", '        if (accounts[_from].balance >= _amount\n', '            && allowed[_from][msg.sender] >= _amount\n', '            && _amount > 0) {\n', '            accounts[_from].balance -= uint112(_amount);\n', '            allowed[_from][msg.sender] -= _amount;\n', '            accounts[_to].balance = _amount.add(accounts[_to].balance).toUINT112();\n', '            emit Transfer(_from, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '    // If this function is called again it overwrites the current allowance with _value.\n', '    function approve(address _spender, uint256 _amount)public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _amount;\n', '        emit Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '    /* Approves and then calls the receiving contract */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '\n', "        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.\n", '        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)\n', '        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.\n', '        //if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }\n', '        ApprovalReceiver(_spender).receiveApproval(msg.sender, _value, this, _extraData);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    function mint0(address _owner, uint256 _amount)public onlyOwner {\n', '    \t\taccounts[_owner].balance = _amount.add(accounts[_owner].balance).toUINT112();\n', '\n', '        accounts[_owner].lastMintedTimestamp = uint32(block.timestamp);\n', '\n', '        //supplies.total = _amount.add(supplies.total).toUINT128();\n', '        emit Transfer(0, _owner, _amount);\n', '    }\n', '    \n', '    // Mint tokens and assign to some one\n', '    function mint(address _owner, uint256 _amount, uint32 timestamp)public onlyOwner{\n', '        accounts[_owner].balance = _amount.add(accounts[_owner].balance).toUINT112();\n', '\n', '        accounts[_owner].lastMintedTimestamp = timestamp;\n', '\n', '        supplies.total = _amount.add(supplies.total).toUINT128();\n', '        emit Transfer(0, _owner, _amount);\n', '    }\n', '\n', '    // Set owner to zero address, to disable mint, and enable token transfer\n', '    function seal()public onlyOwner {\n', '        setOwner(0);\n', '    }\n', '}\n', '\n', 'contract ApprovalReceiver {\n', '    function receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)public;\n', '}']
