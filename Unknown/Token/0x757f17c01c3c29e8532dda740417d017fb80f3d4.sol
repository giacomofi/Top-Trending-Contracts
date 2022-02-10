['pragma solidity 0.4.15;\n', '\n', 'contract ERC20 {\n', '    function totalSupply() constant returns (uint256 totalSupply) {}\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {}\n', '    function transfer(address _recipient, uint256 _value) returns (bool success) {}\n', '    function transferFrom(address _from, address _recipient, uint256 _value) returns (bool success) {}\n', '    function approve(address _spender, uint256 _value) returns (bool success) {}\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}\n', '\n', '    event Transfer(address indexed _from, address indexed _recipient, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract StandardToken is ERC20 {\n', '\n', '\tuint256 public totalSupply;\n', '\tmapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    \n', '    modifier when_can_transfer(address _from, uint256 _value) {\n', '        if (balances[_from] >= _value) _;\n', '    }\n', '\n', '    modifier when_can_receive(address _recipient, uint256 _value) {\n', '        if (balances[_recipient] + _value > balances[_recipient]) _;\n', '    }\n', '\n', '    modifier when_is_allowed(address _from, address _delegate, uint256 _value) {\n', '        if (allowed[_from][_delegate] >= _value) _;\n', '    }\n', '\n', '    function transfer(address _recipient, uint256 _value)\n', '        when_can_transfer(msg.sender, _value)\n', '        when_can_receive(_recipient, _value)\n', '        returns (bool o_success)\n', '    {\n', '        balances[msg.sender] -= _value;\n', '        balances[_recipient] += _value;\n', '        Transfer(msg.sender, _recipient, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _recipient, uint256 _value)\n', '        when_can_transfer(_from, _value)\n', '        when_can_receive(_recipient, _value)\n', '        when_is_allowed(_from, msg.sender, _value)\n', '        returns (bool o_success)\n', '    {\n', '        allowed[_from][msg.sender] -= _value;\n', '        balances[_from] -= _value;\n', '        balances[_recipient] += _value;\n', '        Transfer(_from, _recipient, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool o_success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 o_remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', 'contract ZBCToken is StandardToken {\n', '\n', '\t//FIELDS\n', '\tstring public name = "ZBCoin";\n', '    string public symbol = "ZBC";\n', '    uint public decimals = 3;\n', '\n', '\t//ZBC Token total supply - included decimals below\n', '\tuint public constant MAX_SUPPLY = 300000000000;\n', '\t\n', '\t//ASSIGNED IN INITIALIZATION\n', '\taddress public ownerAddress;  // Address of the contract owner. \n', '\tbool public halted;           // halts the controller if true.\n', '\tmapping(address => uint256) public issuedTokens;\n', '\n', '\tmodifier only_owner() {\n', '\t\tif (msg.sender != ownerAddress) throw;\n', '\t\t_;\n', '\t}\n', '\n', '\t//May only be called if the crowdfund has not been halted\n', '\tmodifier is_not_halted() {\n', '\t\tif (halted) throw;\n', '\t\t_;\n', '\t}\n', '\n', '\t// EVENTS\n', '\tevent Issue(address indexed _recipient, uint _amount);\n', '\n', '\t// Initialization contract assigns address of crowdfund contract and end time.\n', '\tfunction ZBCToken () {\n', '\t\townerAddress = msg.sender;\n', '\t\tbalances[this] += MAX_SUPPLY; // create a pool of token\n', '\t\ttotalSupply += MAX_SUPPLY;    // and set a fix max supply\n', '\t}\n', '\n', '\t// used by owner of contract to halt crowdsale and no longer except ether.\n', '\tfunction toggleHalt(bool _halted) only_owner {\n', '\t\thalted = _halted;\n', '\t}\n', '\n', '\tfunction issueToken(address _recipent, uint _amount) \n', '\t\tonly_owner \n', '\t\tis_not_halted\n', '\t\treturns (bool o_success)\n', '\t{\n', '\t\tthis.transfer(_recipent, _amount);\n', '\t\tIssue(_recipent, _amount);\n', '\t\tissuedTokens[_recipent] += _amount;\n', '\t\treturn true;\n', '\t}\n', '\n', '\t// Transfer amount of tokens from sender account to recipient.\n', '\t// Only callable after the crowd fund end date.\n', '\tfunction transfer(address _recipient, uint _amount)\n', '\t\tis_not_halted\n', '\t\treturns (bool o_success)\n', '\t{\n', '\t\treturn super.transfer(_recipient, _amount);\n', '\t}\n', '\n', '\t// Transfer amount of tokens from a specified address to a recipient.\n', '\t// Only callable after the crowd fund end date.\n', '\tfunction transferFrom(address _from, address _recipient, uint _amount)\n', '\t\tis_not_halted\n', '\t\treturns (bool o_success)\n', '\t{\n', '\t\treturn super.transferFrom(_from, _recipient, _amount);\n', '\t}\n', '}']
['pragma solidity 0.4.15;\n', '\n', 'contract ERC20 {\n', '    function totalSupply() constant returns (uint256 totalSupply) {}\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {}\n', '    function transfer(address _recipient, uint256 _value) returns (bool success) {}\n', '    function transferFrom(address _from, address _recipient, uint256 _value) returns (bool success) {}\n', '    function approve(address _spender, uint256 _value) returns (bool success) {}\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}\n', '\n', '    event Transfer(address indexed _from, address indexed _recipient, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract StandardToken is ERC20 {\n', '\n', '\tuint256 public totalSupply;\n', '\tmapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    \n', '    modifier when_can_transfer(address _from, uint256 _value) {\n', '        if (balances[_from] >= _value) _;\n', '    }\n', '\n', '    modifier when_can_receive(address _recipient, uint256 _value) {\n', '        if (balances[_recipient] + _value > balances[_recipient]) _;\n', '    }\n', '\n', '    modifier when_is_allowed(address _from, address _delegate, uint256 _value) {\n', '        if (allowed[_from][_delegate] >= _value) _;\n', '    }\n', '\n', '    function transfer(address _recipient, uint256 _value)\n', '        when_can_transfer(msg.sender, _value)\n', '        when_can_receive(_recipient, _value)\n', '        returns (bool o_success)\n', '    {\n', '        balances[msg.sender] -= _value;\n', '        balances[_recipient] += _value;\n', '        Transfer(msg.sender, _recipient, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _recipient, uint256 _value)\n', '        when_can_transfer(_from, _value)\n', '        when_can_receive(_recipient, _value)\n', '        when_is_allowed(_from, msg.sender, _value)\n', '        returns (bool o_success)\n', '    {\n', '        allowed[_from][msg.sender] -= _value;\n', '        balances[_from] -= _value;\n', '        balances[_recipient] += _value;\n', '        Transfer(_from, _recipient, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool o_success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 o_remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', 'contract ZBCToken is StandardToken {\n', '\n', '\t//FIELDS\n', '\tstring public name = "ZBCoin";\n', '    string public symbol = "ZBC";\n', '    uint public decimals = 3;\n', '\n', '\t//ZBC Token total supply - included decimals below\n', '\tuint public constant MAX_SUPPLY = 300000000000;\n', '\t\n', '\t//ASSIGNED IN INITIALIZATION\n', '\taddress public ownerAddress;  // Address of the contract owner. \n', '\tbool public halted;           // halts the controller if true.\n', '\tmapping(address => uint256) public issuedTokens;\n', '\n', '\tmodifier only_owner() {\n', '\t\tif (msg.sender != ownerAddress) throw;\n', '\t\t_;\n', '\t}\n', '\n', '\t//May only be called if the crowdfund has not been halted\n', '\tmodifier is_not_halted() {\n', '\t\tif (halted) throw;\n', '\t\t_;\n', '\t}\n', '\n', '\t// EVENTS\n', '\tevent Issue(address indexed _recipient, uint _amount);\n', '\n', '\t// Initialization contract assigns address of crowdfund contract and end time.\n', '\tfunction ZBCToken () {\n', '\t\townerAddress = msg.sender;\n', '\t\tbalances[this] += MAX_SUPPLY; // create a pool of token\n', '\t\ttotalSupply += MAX_SUPPLY;    // and set a fix max supply\n', '\t}\n', '\n', '\t// used by owner of contract to halt crowdsale and no longer except ether.\n', '\tfunction toggleHalt(bool _halted) only_owner {\n', '\t\thalted = _halted;\n', '\t}\n', '\n', '\tfunction issueToken(address _recipent, uint _amount) \n', '\t\tonly_owner \n', '\t\tis_not_halted\n', '\t\treturns (bool o_success)\n', '\t{\n', '\t\tthis.transfer(_recipent, _amount);\n', '\t\tIssue(_recipent, _amount);\n', '\t\tissuedTokens[_recipent] += _amount;\n', '\t\treturn true;\n', '\t}\n', '\n', '\t// Transfer amount of tokens from sender account to recipient.\n', '\t// Only callable after the crowd fund end date.\n', '\tfunction transfer(address _recipient, uint _amount)\n', '\t\tis_not_halted\n', '\t\treturns (bool o_success)\n', '\t{\n', '\t\treturn super.transfer(_recipient, _amount);\n', '\t}\n', '\n', '\t// Transfer amount of tokens from a specified address to a recipient.\n', '\t// Only callable after the crowd fund end date.\n', '\tfunction transferFrom(address _from, address _recipient, uint _amount)\n', '\t\tis_not_halted\n', '\t\treturns (bool o_success)\n', '\t{\n', '\t\treturn super.transferFrom(_from, _recipient, _amount);\n', '\t}\n', '}']