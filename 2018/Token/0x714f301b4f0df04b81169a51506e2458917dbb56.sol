['pragma solidity ^0.4.16;\n', '\n', 'contract XBYR{\n', '\n', '\n', '\n', '    uint256 constant private MAX_UINT256 = 2**256 - 1;\n', '\n', '    mapping (address => uint256) public balances;\n', '\n', '    mapping (address => mapping (address => uint256)) public allowed;\n', '\n', '    /*\n', '\n', '    NOTE:\n', '\n', '    The following variables are OPTIONAL vanities. One does not have to include them.\n', '\n', '    They allow one to customise the token contract & in no way influences the core functionality.\n', '\n', '    Some wallets/interfaces might not even bother to look at this information.\n', '\n', '    */\n', '\n', '    uint256 public totalSupply;\n', '\n', '    string public name;                   //fancy name: eg Simon Bucks\n', '\n', '    uint8 public decimals;                //How many decimals to show.\n', '\n', '    string public symbol;                 //An identifier: eg SBX\n', '\n', '     event Transfer(address indexed _from, address indexed _to, uint256 _value); \n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '   \n', '\n', '   \n', '\n', '    function XBYR() public {\n', '\n', '        balances[msg.sender] = 1000000000000;               // Give the creator all initial tokens\n', '\n', '        totalSupply = 1000000000000;                        // Update total supply\n', '\n', '        name = "YRCoin";                                   // Set the name for display purposes\n', '\n', '        decimals =4;                            // Amount of decimals for display purposes\n', '\n', '        symbol = "XBYR";                               // Set the symbol for display purposes\n', '\n', '    }\n', '\n', '\n', '\n', '\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '\n', '        require(balances[msg.sender] >= _value);\n', '\n', '        balances[msg.sender] -= _value;\n', '\n', '        balances[_to] += _value;\n', '\n', '        Transfer(msg.sender, _to, _value);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '\n', '        uint256 allowance = allowed[_from][msg.sender];\n', '\n', '        require(balances[_from] >= _value && allowance >= _value);\n', '\n', '        balances[_to] += _value;\n', '\n', '        balances[_from] -= _value;\n', '\n', '        if (allowance < MAX_UINT256) {\n', '\n', '            allowed[_from][msg.sender] -= _value;\n', '\n', '        }\n', '\n', '        Transfer(_from, _to, _value);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '\n', '        return balances[_owner];\n', '\n', '    }\n', '\n', '\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '\n', '        return allowed[_owner][_spender];\n', '\n', '    }   \n', '\n', '}']