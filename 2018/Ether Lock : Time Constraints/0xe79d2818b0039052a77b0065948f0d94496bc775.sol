['pragma solidity 0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20 {\n', '  function totalSupply()public view returns (uint total_Supply);\n', '  function balanceOf(address who)public view returns (uint256);\n', '  function allowance(address owner, address spender)public view returns (uint);\n', '  function transferFrom(address from, address to, uint value)public returns (bool ok);\n', '  function approve(address spender, uint value)public returns (bool ok);\n', '  function transfer(address to, uint value)public returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', 'contract INFLIV is ERC20\n', '{ using SafeMath for uint256;\n', '    // Name of the token\n', '    string public constant name = "INFLIV";\n', '\n', '    // Symbol of token\n', '    string public constant symbol = "IFV";\n', '    uint8 public constant decimals = 18;\n', '    uint public _totalsupply = 70000000 * 10 ** 18; // 70 million total supply // muliplies dues to decimal precision\n', '    address public owner;                    // Owner of this contract\n', '    uint256 public _price_tokn_PRE = 6000;  // 1 Ether = 6000 coins\n', '    uint256 public _price_tokn_ICO_first = 3800;   // 1 Ether = 3800 coins\n', '    uint256 public _price_tokn_ICO_second = 2600;   // 1 Ether = 2600 coins\n', '    uint256 no_of_tokens;\n', '    uint256 bonus_token;\n', '    uint256 total_token;\n', '    bool stopped = false;\n', '    uint256 public pre_startdate;\n', '    uint256 public ico1_startdate;\n', '    uint256 ico_first;\n', '    uint256 ico_second;\n', '    uint256 pre_enddate;\n', '  \n', '    uint256 public eth_received; // total ether received in the contract\n', '    uint256 maxCap_public =  42000000 * 10 **18;  //  42 million in Public Sale\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '    \n', '     enum Stages {\n', '        NOTSTARTED,\n', '        PREICO,\n', '        ICO,\n', '        PAUSED,\n', '        ENDED\n', '    }\n', '    Stages public stage;\n', '    \n', '    modifier atStage(Stages _stage) {\n', '        if (stage != _stage)\n', '            // Contract not in expected state\n', '            revert();\n', '        _;\n', '    }\n', '    \n', '     modifier onlyOwner() {\n', '        if (msg.sender != owner) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    function INFLIV() public\n', '    {\n', '        owner = msg.sender;\n', '        balances[owner] = 28000000 * 10 **18; // 28 million to owner\n', '        stage = Stages.NOTSTARTED;\n', '        Transfer(0, owner, balances[owner]);\n', '    }\n', '     \n', '      function () public payable \n', '    \n', '    {\n', '              require(stage != Stages.ENDED);\n', '        require(!stopped && msg.sender != owner);\n', '            if( stage == Stages.PREICO && now <= pre_enddate )\n', '            { \n', '                require (eth_received <= 100 ether);\n', '              eth_received = (eth_received).add(msg.value);\n', '              no_of_tokens =((msg.value).mul(_price_tokn_PRE));\n', '                bonus_token = ((no_of_tokens).mul(50)).div(100); // 50% bonus token\n', '                total_token = no_of_tokens + bonus_token;\n', '                transferTokens(msg.sender,total_token);\n', '               }\n', '               \n', '             else if(stage == Stages.ICO && now <= ico_second){\n', '                    \n', '                if( now < ico_first )\n', '            {\n', '              no_of_tokens =(msg.value).mul(_price_tokn_ICO_first);\n', '                bonus_token = ((no_of_tokens).mul(25)).div(100); // 25% bonus token\n', '                total_token = no_of_tokens + bonus_token;\n', '                transferTokens(msg.sender,total_token);\n', '                \n', '                \n', '            }   \n', '            \n', '              else if(now >= ico_first && now < ico_second)\n', '            {\n', '                \n', '                \n', '                  no_of_tokens =(msg.value).mul(_price_tokn_ICO_first);\n', '                bonus_token = ((no_of_tokens).mul(10)).div(100); // 10% bonus token\n', '                total_token = no_of_tokens + bonus_token;\n', '                transferTokens(msg.sender,total_token);\n', '                \n', '        }\n', '             }\n', '        else\n', '        {\n', '            revert();\n', '        }\n', '    \n', '    }\n', '     function start_PREICO() public onlyOwner atStage(Stages.NOTSTARTED)\n', '      {\n', '          stage = Stages.PREICO;\n', '          stopped = false;\n', '           balances[address(this)] =  maxCap_public;\n', '          pre_startdate = now;\n', '          pre_enddate = now + 20 days;\n', '          Transfer(0, address(this), balances[address(this)]);\n', '          }\n', '      \n', '      function start_ICO() public onlyOwner atStage(Stages.PREICO)\n', '      {\n', '          require(now > pre_enddate || eth_received >= 100 ether);\n', '          stage = Stages.ICO;\n', '          stopped = false;\n', '          ico1_startdate = now;\n', '           ico_first = now + 20 days;\n', '          ico_second = ico_first + 20 days;\n', '          Transfer(0, address(this), balances[address(this)]);\n', '      }\n', '    \n', '    // called by the owner, pause ICO\n', '    function PauseICO() external onlyOwner\n', '    {\n', '        stopped = true;\n', '       }\n', '\n', '    // called by the owner , resumes ICO\n', '    function ResumeICO() external onlyOwner\n', '    {\n', '        stopped = false;\n', '      }\n', '   \n', '     \n', '     \n', '     function end_ICO() external onlyOwner atStage(Stages.ICO)\n', '     {\n', '         require(now > ico_second);\n', '         stage = Stages.ENDED;\n', '         _totalsupply = (_totalsupply).sub(balances[address(this)]);\n', '         balances[address(this)] = 0;\n', '         Transfer(address(this), 0 , balances[address(this)]);\n', '         \n', '     }\n', '\n', '    // what is the total supply of the ech tokens\n', '     function totalSupply() public view returns (uint256 total_Supply) {\n', '         total_Supply = _totalsupply;\n', '     }\n', '    \n', '    // What is the balance of a particular account?\n', '     function balanceOf(address _owner)public view returns (uint256 balance) {\n', '         return balances[_owner];\n', '     }\n', '    \n', '    // Send _value amount of tokens from address _from to address _to\n', '     // The transferFrom method is used for a withdraw workflow, allowing contracts to send\n', '     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge\n', '     // fees in sub-currencies; the command should fail unless the _from account has\n', '     // deliberately authorized the sender of the message via some mechanism; we propose\n', '     // these standardized APIs for approval:\n', '     function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {\n', '     require( _to != 0x0);\n', '     require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);\n', '     balances[_from] = (balances[_from]).sub(_amount);\n', '     allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);\n', '     balances[_to] = (balances[_to]).add(_amount);\n', '     Transfer(_from, _to, _amount);\n', '     return true;\n', '         }\n', '    \n', '   // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '     // If this function is called again it overwrites the current allowance with _value.\n', '     function approve(address _spender, uint256 _amount)public returns (bool success) {\n', '         require( _spender != 0x0);\n', '         allowed[msg.sender][_spender] = _amount;\n', '         Approval(msg.sender, _spender, _amount);\n', '         return true;\n', '     }\n', '  \n', '     function allowance(address _owner, address _spender)public view returns (uint256 remaining) {\n', '         require( _owner != 0x0 && _spender !=0x0);\n', '         return allowed[_owner][_spender];\n', '   }\n', '\n', '     // Transfer the balance from owner&#39;s account to another account\n', '     function transfer(address _to, uint256 _amount)public returns (bool success) {\n', '        require( _to != 0x0);\n', '        require(balances[msg.sender] >= _amount && _amount >= 0);\n', '        balances[msg.sender] = (balances[msg.sender]).sub(_amount);\n', '        balances[_to] = (balances[_to]).add(_amount);\n', '        Transfer(msg.sender, _to, _amount);\n', '             return true;\n', '         }\n', '    \n', '          // Transfer the balance from owner&#39;s account to another account\n', '    function transferTokens(address _to, uint256 _amount) private returns(bool success) {\n', '        require( _to != 0x0);       \n', '        require(balances[address(this)] >= _amount && _amount > 0);\n', '        balances[address(this)] = (balances[address(this)]).sub(_amount);\n', '        balances[_to] = (balances[_to]).add(_amount);\n', '        Transfer(address(this), _to, _amount);\n', '        return true;\n', '        }\n', ' \n', '    \n', '    function drain() external onlyOwner {\n', '        owner.transfer(this.balance);\n', '    }\n', '    \n', '}']
['pragma solidity 0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20 {\n', '  function totalSupply()public view returns (uint total_Supply);\n', '  function balanceOf(address who)public view returns (uint256);\n', '  function allowance(address owner, address spender)public view returns (uint);\n', '  function transferFrom(address from, address to, uint value)public returns (bool ok);\n', '  function approve(address spender, uint value)public returns (bool ok);\n', '  function transfer(address to, uint value)public returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', 'contract INFLIV is ERC20\n', '{ using SafeMath for uint256;\n', '    // Name of the token\n', '    string public constant name = "INFLIV";\n', '\n', '    // Symbol of token\n', '    string public constant symbol = "IFV";\n', '    uint8 public constant decimals = 18;\n', '    uint public _totalsupply = 70000000 * 10 ** 18; // 70 million total supply // muliplies dues to decimal precision\n', '    address public owner;                    // Owner of this contract\n', '    uint256 public _price_tokn_PRE = 6000;  // 1 Ether = 6000 coins\n', '    uint256 public _price_tokn_ICO_first = 3800;   // 1 Ether = 3800 coins\n', '    uint256 public _price_tokn_ICO_second = 2600;   // 1 Ether = 2600 coins\n', '    uint256 no_of_tokens;\n', '    uint256 bonus_token;\n', '    uint256 total_token;\n', '    bool stopped = false;\n', '    uint256 public pre_startdate;\n', '    uint256 public ico1_startdate;\n', '    uint256 ico_first;\n', '    uint256 ico_second;\n', '    uint256 pre_enddate;\n', '  \n', '    uint256 public eth_received; // total ether received in the contract\n', '    uint256 maxCap_public =  42000000 * 10 **18;  //  42 million in Public Sale\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '    \n', '     enum Stages {\n', '        NOTSTARTED,\n', '        PREICO,\n', '        ICO,\n', '        PAUSED,\n', '        ENDED\n', '    }\n', '    Stages public stage;\n', '    \n', '    modifier atStage(Stages _stage) {\n', '        if (stage != _stage)\n', '            // Contract not in expected state\n', '            revert();\n', '        _;\n', '    }\n', '    \n', '     modifier onlyOwner() {\n', '        if (msg.sender != owner) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    function INFLIV() public\n', '    {\n', '        owner = msg.sender;\n', '        balances[owner] = 28000000 * 10 **18; // 28 million to owner\n', '        stage = Stages.NOTSTARTED;\n', '        Transfer(0, owner, balances[owner]);\n', '    }\n', '     \n', '      function () public payable \n', '    \n', '    {\n', '              require(stage != Stages.ENDED);\n', '        require(!stopped && msg.sender != owner);\n', '            if( stage == Stages.PREICO && now <= pre_enddate )\n', '            { \n', '                require (eth_received <= 100 ether);\n', '              eth_received = (eth_received).add(msg.value);\n', '              no_of_tokens =((msg.value).mul(_price_tokn_PRE));\n', '                bonus_token = ((no_of_tokens).mul(50)).div(100); // 50% bonus token\n', '                total_token = no_of_tokens + bonus_token;\n', '                transferTokens(msg.sender,total_token);\n', '               }\n', '               \n', '             else if(stage == Stages.ICO && now <= ico_second){\n', '                    \n', '                if( now < ico_first )\n', '            {\n', '              no_of_tokens =(msg.value).mul(_price_tokn_ICO_first);\n', '                bonus_token = ((no_of_tokens).mul(25)).div(100); // 25% bonus token\n', '                total_token = no_of_tokens + bonus_token;\n', '                transferTokens(msg.sender,total_token);\n', '                \n', '                \n', '            }   \n', '            \n', '              else if(now >= ico_first && now < ico_second)\n', '            {\n', '                \n', '                \n', '                  no_of_tokens =(msg.value).mul(_price_tokn_ICO_first);\n', '                bonus_token = ((no_of_tokens).mul(10)).div(100); // 10% bonus token\n', '                total_token = no_of_tokens + bonus_token;\n', '                transferTokens(msg.sender,total_token);\n', '                \n', '        }\n', '             }\n', '        else\n', '        {\n', '            revert();\n', '        }\n', '    \n', '    }\n', '     function start_PREICO() public onlyOwner atStage(Stages.NOTSTARTED)\n', '      {\n', '          stage = Stages.PREICO;\n', '          stopped = false;\n', '           balances[address(this)] =  maxCap_public;\n', '          pre_startdate = now;\n', '          pre_enddate = now + 20 days;\n', '          Transfer(0, address(this), balances[address(this)]);\n', '          }\n', '      \n', '      function start_ICO() public onlyOwner atStage(Stages.PREICO)\n', '      {\n', '          require(now > pre_enddate || eth_received >= 100 ether);\n', '          stage = Stages.ICO;\n', '          stopped = false;\n', '          ico1_startdate = now;\n', '           ico_first = now + 20 days;\n', '          ico_second = ico_first + 20 days;\n', '          Transfer(0, address(this), balances[address(this)]);\n', '      }\n', '    \n', '    // called by the owner, pause ICO\n', '    function PauseICO() external onlyOwner\n', '    {\n', '        stopped = true;\n', '       }\n', '\n', '    // called by the owner , resumes ICO\n', '    function ResumeICO() external onlyOwner\n', '    {\n', '        stopped = false;\n', '      }\n', '   \n', '     \n', '     \n', '     function end_ICO() external onlyOwner atStage(Stages.ICO)\n', '     {\n', '         require(now > ico_second);\n', '         stage = Stages.ENDED;\n', '         _totalsupply = (_totalsupply).sub(balances[address(this)]);\n', '         balances[address(this)] = 0;\n', '         Transfer(address(this), 0 , balances[address(this)]);\n', '         \n', '     }\n', '\n', '    // what is the total supply of the ech tokens\n', '     function totalSupply() public view returns (uint256 total_Supply) {\n', '         total_Supply = _totalsupply;\n', '     }\n', '    \n', '    // What is the balance of a particular account?\n', '     function balanceOf(address _owner)public view returns (uint256 balance) {\n', '         return balances[_owner];\n', '     }\n', '    \n', '    // Send _value amount of tokens from address _from to address _to\n', '     // The transferFrom method is used for a withdraw workflow, allowing contracts to send\n', '     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge\n', '     // fees in sub-currencies; the command should fail unless the _from account has\n', '     // deliberately authorized the sender of the message via some mechanism; we propose\n', '     // these standardized APIs for approval:\n', '     function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {\n', '     require( _to != 0x0);\n', '     require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);\n', '     balances[_from] = (balances[_from]).sub(_amount);\n', '     allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);\n', '     balances[_to] = (balances[_to]).add(_amount);\n', '     Transfer(_from, _to, _amount);\n', '     return true;\n', '         }\n', '    \n', '   // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '     // If this function is called again it overwrites the current allowance with _value.\n', '     function approve(address _spender, uint256 _amount)public returns (bool success) {\n', '         require( _spender != 0x0);\n', '         allowed[msg.sender][_spender] = _amount;\n', '         Approval(msg.sender, _spender, _amount);\n', '         return true;\n', '     }\n', '  \n', '     function allowance(address _owner, address _spender)public view returns (uint256 remaining) {\n', '         require( _owner != 0x0 && _spender !=0x0);\n', '         return allowed[_owner][_spender];\n', '   }\n', '\n', "     // Transfer the balance from owner's account to another account\n", '     function transfer(address _to, uint256 _amount)public returns (bool success) {\n', '        require( _to != 0x0);\n', '        require(balances[msg.sender] >= _amount && _amount >= 0);\n', '        balances[msg.sender] = (balances[msg.sender]).sub(_amount);\n', '        balances[_to] = (balances[_to]).add(_amount);\n', '        Transfer(msg.sender, _to, _amount);\n', '             return true;\n', '         }\n', '    \n', "          // Transfer the balance from owner's account to another account\n", '    function transferTokens(address _to, uint256 _amount) private returns(bool success) {\n', '        require( _to != 0x0);       \n', '        require(balances[address(this)] >= _amount && _amount > 0);\n', '        balances[address(this)] = (balances[address(this)]).sub(_amount);\n', '        balances[_to] = (balances[_to]).add(_amount);\n', '        Transfer(address(this), _to, _amount);\n', '        return true;\n', '        }\n', ' \n', '    \n', '    function drain() external onlyOwner {\n', '        owner.transfer(this.balance);\n', '    }\n', '    \n', '}']