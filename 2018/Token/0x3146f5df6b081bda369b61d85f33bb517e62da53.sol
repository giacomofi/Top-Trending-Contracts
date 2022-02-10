['pragma solidity ^0.4.21;\n', '\n', '\n', 'contract EIP20Interface {\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '\n', '    function pending(address _pender) public returns (bool success);\n', '    function undoPending(address _pender) public returns (bool success); \n', '\n', '    // solhint-disable-next-line no-simple-event-func-name\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Pending(address indexed _pender, uint256 _value, bool isPending);\n', '}\n', '\n', 'contract EIP20 is EIP20Interface {\n', '    address public owner;\n', '\n', '    mapping (address => uint256) public balances;\n', '    mapping (address => uint256) public hold_balances;\n', '    mapping (address => mapping (address => uint256)) public allowed;\n', '    /*\n', '    NOTE:\n', '    The following variables are OPTIONAL vanities. One does not have to include them.\n', '    They allow one to customise the token contract & in no way influences the core functionality.\n', '    Some wallets/interfaces might not even bother to look at this information.\n', '    */\n', '    string public name;                   //fancy name: eg Simon Bucks\n', '    uint8 public decimals;                //How many decimals to show.\n', '    string public symbol;                 //An identifier: eg SBX\n', '\n', '    function EIP20() public {\n', '        owner = msg.sender;               // Update total supply\n', '        name = "WORLDWIDEREAL";                                   // Set the name for display purposes\n', '        decimals = 8;                            // Amount of decimals for display purposes\n', '        symbol = "WWR";                               // Set the symbol for display purposes\n', '        balances[msg.sender] = 560000000*10**uint256(decimals);               // Give the creator all initial tokens\n', '        totalSupply = 560000000*10**uint256(decimals);  \n', '    }\n', '\n', '    function setOwner(address _newOwner) public returns (bool success) {\n', '        if(owner == msg.sender)\n', '\t\t    owner = _newOwner;\n', '        return true;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        uint256 allowance = allowed[_from][msg.sender];\n', '        require(balances[_from] >= _value && allowance >= _value);\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '        allowed[_from][msg.sender] -= _value;\n', '        emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function pending(address _pender) public returns (bool success){\n', '        uint256 pender_balances = balances[_pender];\n', '        if(owner!=msg.sender)\n', '            return false;\n', '        else if(pender_balances > 0){\n', '            balances[_pender] = 0; //Hold this amount;\n', '            hold_balances[_pender] = hold_balances[_pender] + pender_balances;\n', '            emit Pending(_pender,pender_balances, true);\n', '            pender_balances = 0;\n', '            return true;\n', '        }\n', '        else if(pender_balances <= 0)\n', '        {\n', '            return false;\n', '        }\n', '        return false;\n', '            \n', '    }\n', '\n', '    function undoPending(address _pender) public returns (bool success){\n', '        uint256 pender_balances = hold_balances[_pender];\n', '        if(owner!=msg.sender)\n', '            return false;\n', '        else if(pender_balances > 0){\n', '            hold_balances[_pender] = 0;\n', '            balances[_pender] = balances[_pender] + pender_balances;\n', '            emit Pending(_pender,pender_balances, false);\n', '            pender_balances = 0;\n', '            return true;\n', '        }\n', '        else if(pender_balances <= 0)\n', '        {\n', '            return false;\n', '        }\n', '        return false;   \n', '    }\n', '}']
['pragma solidity ^0.4.21;\n', '\n', '\n', 'contract EIP20Interface {\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '\n', '    function pending(address _pender) public returns (bool success);\n', '    function undoPending(address _pender) public returns (bool success); \n', '\n', '    // solhint-disable-next-line no-simple-event-func-name\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Pending(address indexed _pender, uint256 _value, bool isPending);\n', '}\n', '\n', 'contract EIP20 is EIP20Interface {\n', '    address public owner;\n', '\n', '    mapping (address => uint256) public balances;\n', '    mapping (address => uint256) public hold_balances;\n', '    mapping (address => mapping (address => uint256)) public allowed;\n', '    /*\n', '    NOTE:\n', '    The following variables are OPTIONAL vanities. One does not have to include them.\n', '    They allow one to customise the token contract & in no way influences the core functionality.\n', '    Some wallets/interfaces might not even bother to look at this information.\n', '    */\n', '    string public name;                   //fancy name: eg Simon Bucks\n', '    uint8 public decimals;                //How many decimals to show.\n', '    string public symbol;                 //An identifier: eg SBX\n', '\n', '    function EIP20() public {\n', '        owner = msg.sender;               // Update total supply\n', '        name = "WORLDWIDEREAL";                                   // Set the name for display purposes\n', '        decimals = 8;                            // Amount of decimals for display purposes\n', '        symbol = "WWR";                               // Set the symbol for display purposes\n', '        balances[msg.sender] = 560000000*10**uint256(decimals);               // Give the creator all initial tokens\n', '        totalSupply = 560000000*10**uint256(decimals);  \n', '    }\n', '\n', '    function setOwner(address _newOwner) public returns (bool success) {\n', '        if(owner == msg.sender)\n', '\t\t    owner = _newOwner;\n', '        return true;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        uint256 allowance = allowed[_from][msg.sender];\n', '        require(balances[_from] >= _value && allowance >= _value);\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '        allowed[_from][msg.sender] -= _value;\n', '        emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function pending(address _pender) public returns (bool success){\n', '        uint256 pender_balances = balances[_pender];\n', '        if(owner!=msg.sender)\n', '            return false;\n', '        else if(pender_balances > 0){\n', '            balances[_pender] = 0; //Hold this amount;\n', '            hold_balances[_pender] = hold_balances[_pender] + pender_balances;\n', '            emit Pending(_pender,pender_balances, true);\n', '            pender_balances = 0;\n', '            return true;\n', '        }\n', '        else if(pender_balances <= 0)\n', '        {\n', '            return false;\n', '        }\n', '        return false;\n', '            \n', '    }\n', '\n', '    function undoPending(address _pender) public returns (bool success){\n', '        uint256 pender_balances = hold_balances[_pender];\n', '        if(owner!=msg.sender)\n', '            return false;\n', '        else if(pender_balances > 0){\n', '            hold_balances[_pender] = 0;\n', '            balances[_pender] = balances[_pender] + pender_balances;\n', '            emit Pending(_pender,pender_balances, false);\n', '            pender_balances = 0;\n', '            return true;\n', '        }\n', '        else if(pender_balances <= 0)\n', '        {\n', '            return false;\n', '        }\n', '        return false;   \n', '    }\n', '}']