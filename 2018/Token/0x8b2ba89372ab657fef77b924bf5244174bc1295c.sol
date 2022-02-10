['// Verfication token for U42 token distribution\n', '//\n', "// Standard ERC-20 methods and the SafeMath library are adapated from OpenZeppelin's standard contract types\n", '// as at https://github.com/OpenZeppelin/openzeppelin-solidity/commit/5daaf60d11ee2075260d0f3adfb22b1c536db983\n', '// note that uint256 is used explicitly in place of uint\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '//safemath extensions added to uint256\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Verify_U42 {\n', '\t//use OZ SafeMath to avoid uint256 overflows\n', '\tusing SafeMath for uint256;\n', '\n', '\tstring public constant name = "Verification token for U42 distribution";\n', '\tstring public constant symbol = "VU42";\n', '\tuint8 public constant decimals = 18;\n', '\tuint256 public constant initialSupply = 525000000 * (10 ** uint256(decimals));\n', '\tuint256 internal totalSupply_ = initialSupply;\n', '\taddress public contractOwner;\n', '\n', '\t//token balances\n', '\tmapping(address => uint256) balances;\n', '\n', '\t//for each balance address, map allowed addresses to amount allowed\n', '\tmapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\t//methods emit the following events (note that these are a subset \n', '\tevent Transfer (\n', '\t\taddress indexed from, \n', '\t\taddress indexed to, \n', '\t\tuint256 value );\n', '\n', '\tevent TokensBurned (\n', '\t\taddress indexed burner, \n', '\t\tuint256 value );\n', '\n', '\tevent Approval (\n', '\t\taddress indexed owner,\n', '\t\taddress indexed spender,\n', '\t\tuint256 value );\n', '\n', '\n', '\tconstructor() public {\n', '\t\t//contract creator holds all tokens at creation\n', '\t\tbalances[msg.sender] = totalSupply_;\n', '\n', '\t\t//record contract owner for later reference (e.g. in ownerBurn)\n', '\t\tcontractOwner=msg.sender;\n', '\n', '\t\t//indicate all tokens were sent to contract address\n', '\t\temit Transfer(address(0), msg.sender, totalSupply_);\n', '\t}\n', '\n', '\tfunction ownerBurn ( \n', '\t\t\tuint256 _value )\n', '\t\tpublic returns (\n', '\t\t\tbool success) {\n', '\n', '\t\t//only the contract owner can burn tokens\n', '\t\trequire(msg.sender == contractOwner);\n', '\n', '\t\t//can only burn tokens held by the owner\n', '\t\trequire(_value <= balances[contractOwner]);\n', '\n', '\t\t//total supply of tokens is decremented when burned\n', '\t\ttotalSupply_ = totalSupply_.sub(_value);\n', '\n', "\t\t//balance of the contract owner is reduced (the contract owner's tokens are burned)\n", '\t\tbalances[contractOwner] = balances[contractOwner].sub(_value);\n', '\n', '\t\t//burning tokens emits a transfer to 0, as well as TokensBurned\n', '\t\temit Transfer(contractOwner, address(0), _value);\n', '\t\temit TokensBurned(contractOwner, _value);\n', '\n', '\t\treturn true;\n', '\n', '\t}\n', '\t\n', '\t\n', '\tfunction totalSupply ( ) public view returns (\n', '\t\tuint256 ) {\n', '\n', '\t\treturn totalSupply_;\n', '\t}\n', '\n', '\tfunction balanceOf (\n', '\t\t\taddress _owner ) \n', '\t\tpublic view returns (\n', '\t\t\tuint256 ) {\n', '\n', '\t\treturn balances[_owner];\n', '\t}\n', '\n', '\tfunction transfer (\n', '\t\t\taddress _to, \n', '\t\t\tuint256 _value ) \n', '\t\tpublic returns (\n', '\t\t\tbool ) {\n', '\n', '\t\trequire(_to != address(0));\n', '\t\trequire(_value <= balances[msg.sender]);\n', '\n', '\t\tbalances[msg.sender] = balances[msg.sender].sub(_value);\n', '\t\tbalances[_to] = balances[_to].add(_value);\n', '\n', '\t\temit Transfer(msg.sender, _to, _value);\n', '\t\treturn true;\n', '\t}\n', '\n', '   \t//changing approval with this method has the same underlying issue as https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   \t//in that transaction order can be modified in a block to spend, change approval, spend again\n', '   \t//the method is kept for ERC-20 compatibility, but a set to zero, set again or use of the below increase/decrease should be used instead\n', '\tfunction approve (\n', '\t\t\taddress _spender, \n', '\t\t\tuint256 _value ) \n', '\t\tpublic returns (\n', '\t\t\tbool ) {\n', '\n', '\t\tallowed[msg.sender][_spender] = _value;\n', '\n', '\t\temit Approval(msg.sender, _spender, _value);\n', '\t\treturn true;\n', '\t}\n', '\n', '\tfunction increaseApproval (\n', '\t\t\taddress _spender, \n', '\t\t\tuint256 _addedValue ) \n', '\t\tpublic returns (\n', '\t\t\tbool ) {\n', '\n', '\t\tallowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '\n', '\t\temit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\t\treturn true;\n', '\t}\n', '\n', '\tfunction decreaseApproval (\n', '\t\t\taddress _spender,\n', '\t\t\tuint256 _subtractedValue ) \n', '\t\tpublic returns (\n', '\t\t\tbool ) {\n', '\n', '\t\tuint256 oldValue = allowed[msg.sender][_spender];\n', '\n', '\t\tif (_subtractedValue > oldValue) {\n', '\t\t\tallowed[msg.sender][_spender] = 0;\n', '\t\t} else {\n', '\t\t\tallowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '\t\t}\n', '\n', '\t\temit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\t\treturn true;\n', '\t}\n', '\n', '\tfunction allowance (\n', '\t\t\taddress _owner, \n', '\t\t\taddress _spender ) \n', '\t\tpublic view returns (\n', '\t\t\tuint256 remaining ) {\n', '\n', '\t\treturn allowed[_owner][_spender];\n', '\t}\n', '\n', '\tfunction transferFrom (\n', '\t\t\taddress _from, \n', '\t\t\taddress _to, \n', '\t\t\tuint256 _value ) \n', '\t\tpublic returns (\n', '\t\t\tbool ) {\n', '\n', '\t\trequire(_to != address(0));\n', '\t\trequire(_value <= balances[_from]);\n', '\t\trequire(_value <= allowed[_from][msg.sender]);\n', '\n', '\t\tbalances[_from] = balances[_from].sub(_value);\n', '\t\tbalances[_to] = balances[_to].add(_value);\n', '\t\tallowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\t\temit Transfer(_from, _to, _value);\n', '\t\treturn true;\n', '\t}\n', '\n', '}']