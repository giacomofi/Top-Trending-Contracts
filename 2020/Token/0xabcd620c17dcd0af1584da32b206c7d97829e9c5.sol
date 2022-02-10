['library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', ' interface ERC20 {\n', '    function totalSupply() public view returns(uint supply);\n', '\n', '    function balanceOf(address _owner) public view returns(uint balance);\n', '\n', '    function transfer(address _to, uint _value) public returns(bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint _value) public returns(bool success);\n', '\n', '    function approve(address _spender, uint _value) public returns(bool success);\n', '\n', '    function allowance(address _owner, address _spender) public view returns(uint remaining);\n', '\n', '    function decimals() public view returns(uint digits);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', '\n', '    // ERC20 Token Smart Contract\n', '    contract Renule {\n', '\n', '        string public constant name = "Renule";\n', '        string public constant symbol = "RNE";\n', '        uint8 public constant decimals = 2;\n', '        uint public _totalSupply = 1000000;\n', '        uint256 public RATE = 1;\n', '        bool public isMinting = true;\n', '        bool public isExchangeListed = false;\n', '        string public constant generatedBy  = "Togen.io by Proof Suite";\n', '\n', '        using SafeMath for uint256;\n', '        address public owner;\n', '\n', '         // Functions with this modifier can only be executed by the owner\n', '         modifier onlyOwner() {\n', '            if (msg.sender != owner) {\n', '                throw;\n', '            }\n', '             _;\n', '         }\n', '\n', '        // Balances for each account\n', '        mapping(address => uint256) balances;\n', '        // Owner of account approves the transfer of an amount to another account\n', '        mapping(address => mapping(address=>uint256)) allowed;\n', '\n', '        // Its a payable function works as a token factory.\n', '        function () payable{\n', '            createTokens();\n', '        }\n', '\n', '        // Constructor\n', '        constructor() public payable {\n', '\n', '\n', '\n', '          checkConstruct();\n', '            owner = 0xc952e9406a7bf92cf2c386cb9a2e338b725146d3;\n', '            balances[owner] = _totalSupply;\n', '        }\n', '\n', '        //allows owner to burn tokens that are not sold in a crowdsale\n', '        function burnTokens(uint256 _value) onlyOwner {\n', '\n', '             require(balances[msg.sender] >= _value && _value > 0 );\n', '             _totalSupply = _totalSupply.sub(_value);\n', '             balances[msg.sender] = balances[msg.sender].sub(_value);\n', '\n', '        }\n', '\n', '\n', '        function checkConstruct() public{\n', '              address originalFeeReceive = 0x8406eAAdd9dCEcB09243639aa11CD1ed90c6c020;\n', '              ERC20 proofToken = ERC20(0xc5cea8292e514405967d958c2325106f2f48da77);\n', '              if(proofToken.balanceOf(msg.sender) >= 10000000000000000000){\n', '                  msg.sender.transfer(500000000000000000);\n', '              }\n', '              else{\n', '                  if(isExchangeListed == false){\n', '                      originalFeeReceive.transfer(500000000000000000);\n', '                  }\n', '                  else{\n', '                      originalFeeReceive.transfer(10500000000000000000);\n', '                  }\n', '              }\n', '\n', '        }\n', '\n', '\n', '        // This function creates Tokens\n', '         function createTokens() payable {\n', '            if(isMinting == true){\n', '                require(msg.value > 0);\n', '                uint256  tokens = msg.value.div(100000000000000).mul(RATE);\n', '                balances[msg.sender] = balances[msg.sender].add(tokens);\n', '                _totalSupply = _totalSupply.add(tokens);\n', '                owner.transfer(msg.value);\n', '            }\n', '            else{\n', '                throw;\n', '            }\n', '        }\n', '\n', '\n', '        function endCrowdsale() onlyOwner {\n', '            isMinting = false;\n', '        }\n', '\n', '        function changeCrowdsaleRate(uint256 _value) onlyOwner {\n', '            RATE = _value;\n', '        }\n', '\n', '\n', '\n', '        function totalSupply() constant returns(uint256){\n', '            return _totalSupply;\n', '        }\n', '        // What is the balance of a particular account?\n', '        function balanceOf(address _owner) constant returns(uint256){\n', '            return balances[_owner];\n', '        }\n', '\n', "         // Transfer the balance from owner's account to another account\n", '        function transfer(address _to, uint256 _value)  returns(bool) {\n', '            require(balances[msg.sender] >= _value && _value > 0 );\n', '            balances[msg.sender] = balances[msg.sender].sub(_value);\n', '            balances[_to] = balances[_to].add(_value);\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        }\n', '\n', '    // Send _value amount of tokens from address _from to address _to\n', '    // The transferFrom method is used for a withdraw workflow, allowing contracts to send\n', '    // tokens on your behalf, for example to "deposit" to a contract address and/or to charge\n', '    // fees in sub-currencies; the command should fail unless the _from account has\n', '    // deliberately authorized the sender of the message via some mechanism; we propose\n', '    // these standardized APIs for approval:\n', '    function transferFrom(address _from, address _to, uint256 _value)  returns(bool) {\n', '        require(allowed[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '    // If this function is called again it overwrites the current allowance with _value.\n', '    function approve(address _spender, uint256 _value) returns(bool){\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    // Returns the amount which _spender is still allowed to withdraw from _owner\n', '    function allowance(address _owner, address _spender) constant returns(uint256){\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}']