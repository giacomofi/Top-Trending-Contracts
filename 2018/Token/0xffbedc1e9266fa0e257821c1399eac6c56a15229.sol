['pragma solidity ^0.4.4;\n', '\n', 'contract Token {\n', '\n', '\t/// @return total amount of tokens\n', '\tfunction totalSupply() constant returns (uint256 supply) {}\n', '\n', '\t/// @param _owner The address from which the balance will be retrieved\n', '\t/// @return The balance\n', '\tfunction balanceOf(address _owner) constant returns (uint256 balance) {}\n', '\n', '\t/// @notice send `_value` token to `_to` from `msg.sender`\n', '\t/// @param _to The address of the recipient\n', '\t/// @param _value The amount of token to be transferred\n', '\t/// @return Whether the transfer was successful or not\n', '\tfunction transfer(address _to, uint256 _value) returns (bool success) {}\n', '\n', '\t/// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '\t/// @param _from The address of the sender\n', '\t/// @param _to The address of the recipient\n', '\t/// @param _value The amount of token to be transferred\n', '\t/// @return Whether the transfer was successful or not\n', '\tfunction transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}\n', '\n', '\t/// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '\t/// @param _spender The address of the account able to transfer the tokens\n', '\t/// @param _value The amount of wei to be approved for transfer\n', '\t/// @return Whether the approval was successful or not\n', '\tfunction approve(address _spender, uint256 _value) returns (bool success) {}\n', '\n', '\t/// @param _owner The address of the account owning tokens\n', '\t/// @param _spender The address of the account able to transfer the tokens\n', '\t/// @return Amount of remaining tokens allowed to spent\n', '\tfunction allowance(address _owner, address _spender) constant returns (uint256 remaining) {}\n', '\n', '\tevent Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\tevent Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\t\n', '}\n', '\n', '\n', '\n', 'contract StandardToken is Token {\n', '\n', '\tfunction transfer(address _to, uint256 _value) returns (bool success) {\n', "\t\t//Default assumes totalSupply can't be over max (2^256 - 1).\n", "\t\t//If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.\n", '\t\t//Replace the if with this one instead.\n', '\t\t//if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '\t\tif (balances[msg.sender] >= _value && _value > 0) {\n', '\t\t\tbalances[msg.sender] -= _value;\n', '\t\t\tbalances[_to] += _value;\n', '\t\t\tTransfer(msg.sender, _to, _value);\n', '\t\t\treturn true;\n', '\t\t} else { return false; }\n', '\t}\n', '\n', '\tfunction transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '\t\t//same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '\t\t//if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '\t\tif (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '\t\t\tbalances[_to] += _value;\n', '\t\t\tbalances[_from] -= _value;\n', '\t\t\tallowed[_from][msg.sender] -= _value;\n', '\t\t\tTransfer(_from, _to, _value);\n', '\t\t\treturn true;\n', '\t\t} else { return false; }\n', '\t}\n', '\n', '\tfunction balanceOf(address _owner) constant returns (uint256 balance) {\n', '\t\treturn balances[_owner];\n', '\t}\n', '\n', '\tfunction approve(address _spender, uint256 _value) returns (bool success) {\n', '\t\tallowed[msg.sender][_spender] = _value;\n', '\t\tApproval(msg.sender, _spender, _value);\n', '\t\treturn true;\n', '\t}\n', '\n', '\tfunction allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '\t  return allowed[_owner][_spender];\n', '\t}\n', '\n', '\tmapping (address => uint256) balances;\n', '\tmapping (address => mapping (address => uint256)) allowed;\n', '\tuint256 public totalSupply;\n', '}\n', '\n', '\n', "//name this contract whatever you'd like\n", 'contract AMDToken is StandardToken {\n', '\n', '\tfunction () {\n', '\t\t//if ether is sent to this address, send it back.\n', '\t\tthrow;\n', '\t}\n', '\n', '\t/* Public variables of the token */\n', '\n', '\t/*\n', '\tNOTE:\n', '\tThe following variables are OPTIONAL vanities. One does not have to include them.\n', '\tThey allow one to customise the token contract & in no way influences the core functionality.\n', '\tSome wallets/interfaces might not even bother to look at this information.\n', '\t*/\n', '\tstring public name;                   //fancy name: eg Simon Bucks\n', "\tuint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.\n", '\tstring public symbol;                 //An identifier: eg SBX\n', "\tstring public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.\n", '\n', '//\n', '// CHANGE THESE VALUES FOR YOUR TOKEN\n', '//\n', '\n', "//make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token\n", '\n', '\tfunction AMDToken(\n', '\t\t) {\n', '\t\tbalances[msg.sender] = 100000000;               // Give the creator all initial tokens (100000 for example)\n', '\t\ttotalSupply = 100000000;                        // Update total supply (100000 for example)\n', '\t\tname = "AMD Token";                                   // Set the name for display purposes\n', '\t\tdecimals = 2;                            // Amount of decimals for display purposes\n', '\t\tsymbol = "AMDT";                               // Set the symbol for display purposes\n', '\t}\n', '\n', '\t/* Approves and then calls the receiving contract */\n', '\tfunction approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '\t\tallowed[msg.sender][_spender] = _value;\n', '\t\tApproval(msg.sender, _spender, _value);\n', '\n', "\t\t//call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.\n", '\t\t//receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)\n', '\t\t//it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.\n', '\t\tif(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }\n', '\t\treturn true;\n', '\t}\n', '}']