['pragma solidity ^0.4.20;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal  pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal  pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure  returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Owned {\n', '\n', '    address public owner;\n', '    address newOwner;\n', '\n', '    modifier only(address _allowed) {\n', '        require(msg.sender == _allowed);\n', '        _;\n', '    }\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) only(owner) public {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() only(newOwner) public {\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '}\n', '\n', 'contract ERC20 is Owned {\n', '    using SafeMath for uint;\n', '\n', '    uint public totalSupply;\n', '    bool public isStarted = false;\n', '    mapping (address => uint) balances;\n', '    mapping (address => mapping (address => uint)) allowed;\n', '\n', '    modifier isStartedOnly() {\n', '        require(isStarted);\n', '        _;\n', '    }\n', '\n', '    modifier isNotStartedOnly() {\n', '        require(!isStarted);\n', '        _;\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '\n', '    function transfer(address _to, uint _value) isStartedOnly public returns (bool success) {\n', '        require(_to != address(0));\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) isStartedOnly public returns (bool success) {\n', '        require(_to != address(0));\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve_fixed(address _spender, uint _currentValue, uint _value) isStartedOnly public returns (bool success) {\n', '        if(allowed[msg.sender][_spender] == _currentValue){\n', '            allowed[msg.sender][_spender] = _value;\n', '            emit Approval(msg.sender, _spender, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function approve(address _spender, uint _value) isStartedOnly public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', 'contract Token is ERC20 {\n', '    using SafeMath for uint;\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\n', '    function Token(string _name, string _symbol, uint8 _decimals) public {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '    }\n', '\n', '    function start() public only(owner) isNotStartedOnly {\n', '        isStarted = true;\n', '    }\n', '\n', '    //================= Crowdsale Only =================\n', '    function mint(address _to, uint _amount) public only(owner) isNotStartedOnly returns(bool) {\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    function multimint(address[] dests, uint[] values) public only(owner) isNotStartedOnly returns (uint) {\n', '        uint i = 0;\n', '        while (i < dests.length) {\n', '           mint(dests[i], values[i]);\n', '           i += 1;\n', '        }\n', '        return(i);\n', '    }\n', '}\n', '\n', 'contract TokenWithoutStart is Owned {\n', '    using SafeMath for uint;\n', '\n', '    mapping (address => uint) balances;\n', '    mapping (address => mapping (address => uint)) allowed;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint public totalSupply;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '\n', '    function TokenWithoutStart(string _name, string _symbol, uint8 _decimals) public {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '    }\n', '\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '        require(_to != address(0));\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {\n', '        require(_to != address(0));\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve_fixed(address _spender, uint _currentValue, uint _value) public returns (bool success) {\n', '        if(allowed[msg.sender][_spender] == _currentValue){\n', '            allowed[msg.sender][_spender] = _value;\n', '            emit Approval(msg.sender, _spender, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function approve(address _spender, uint _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function mint(address _to, uint _amount) public only(owner) returns(bool) {\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    function multimint(address[] dests, uint[] values) public only(owner) returns (uint) {\n', '        uint i = 0;\n', '        while (i < dests.length) {\n', '           mint(dests[i], values[i]);\n', '           i += 1;\n', '        }\n', '        return(i);\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '//This contract is used to distribute tokens reserved for Jury.Online team the terms of distirbution are following:\n', '//after the end of ICO tokens are frozen for 6 months and afterwards each months 10% of tokens is unfrozen\n', '\n', 'contract Vesting {\n', '\n', '    //1. Alexander Shevtsov            0x4C67EB86d70354731f11981aeE91d969e3823c39\n', '    //2. Anastasia Bormotova           0x450Eb50Cc83B155cdeA8b6d47Be77970Cf524368\n', '    //3. Artemiy Pirozhkov             0x9CFf3408a1eB46FE1F9de91f932FDCfEC34A568f\n', '    //4. Konstantin Kudryavtsev        0xA14d9fa5B1b46206026eA51A98CeEd182A91a190\n', '    //5. Marina Kobyakova              0x0465f2fA674bF20Fe9484dB70D8570617495b352\n', '    //6. Nikita Alekseev               0x07F8a6Fb0Ad63abBe21e8ef33523D8368618cd10\n', '    //7. Nikolay Prudnikov             0xF29fE8e258b084d40D9cF1dCF02E5CB29837b6D5\n', '    //8. Valeriy Strechen              0x64B557EaED227B841DcEd9f70918cd8f5ca2Bdab\n', '    //9. Igor Lavrenov                 0x05d1e624eaDF70bb7F8A2B11D39A8a5635e5D007\n', '    \n', '    uint public constant interval = 30 days;\n', '    uint public constant distributionStart = 1540994400; //1st of November\n', '    uint public currentStage;\n', '    uint public stageAmount;\n', '    uint public toSendLeft;\n', '\n', '    address[] public team;\n', '    Token public token;\n', '\n', '    constructor(address[] _team, address _token) {\n', '        token = Token(_token);\n', '        for(uint i=0; i<_team.length; i++) {\n', '            team.push(_team[i]);\n', '        }\n', '    }\n', '\n', '    function makePayouts() {\n', '        require(toSendLeft != 0);\n', '        if (now > interval*currentStage + distributionStart) {\n', '\t\t\tuint balance = stageAmount/team.length;\n', '            for(uint i=0; i<team.length; i++) {\n', '                toSendLeft -= balance;\n', '                require(token.transfer(team[i], balance));\n', '            }\n', '        currentStage+=1;\n', '        }\n', '    }\n', '\n', '    function setToSendLeft() {\n', '        require(toSendLeft == 0);\n', '        toSendLeft = token.balanceOf(address(this));\n', '        stageAmount = toSendLeft/10;\n', '    }\n', '\n', '\n', '\n', '}']
['pragma solidity ^0.4.20;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal  pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal  pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure  returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Owned {\n', '\n', '    address public owner;\n', '    address newOwner;\n', '\n', '    modifier only(address _allowed) {\n', '        require(msg.sender == _allowed);\n', '        _;\n', '    }\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) only(owner) public {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() only(newOwner) public {\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '}\n', '\n', 'contract ERC20 is Owned {\n', '    using SafeMath for uint;\n', '\n', '    uint public totalSupply;\n', '    bool public isStarted = false;\n', '    mapping (address => uint) balances;\n', '    mapping (address => mapping (address => uint)) allowed;\n', '\n', '    modifier isStartedOnly() {\n', '        require(isStarted);\n', '        _;\n', '    }\n', '\n', '    modifier isNotStartedOnly() {\n', '        require(!isStarted);\n', '        _;\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '\n', '    function transfer(address _to, uint _value) isStartedOnly public returns (bool success) {\n', '        require(_to != address(0));\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) isStartedOnly public returns (bool success) {\n', '        require(_to != address(0));\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve_fixed(address _spender, uint _currentValue, uint _value) isStartedOnly public returns (bool success) {\n', '        if(allowed[msg.sender][_spender] == _currentValue){\n', '            allowed[msg.sender][_spender] = _value;\n', '            emit Approval(msg.sender, _spender, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function approve(address _spender, uint _value) isStartedOnly public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', 'contract Token is ERC20 {\n', '    using SafeMath for uint;\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\n', '    function Token(string _name, string _symbol, uint8 _decimals) public {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '    }\n', '\n', '    function start() public only(owner) isNotStartedOnly {\n', '        isStarted = true;\n', '    }\n', '\n', '    //================= Crowdsale Only =================\n', '    function mint(address _to, uint _amount) public only(owner) isNotStartedOnly returns(bool) {\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    function multimint(address[] dests, uint[] values) public only(owner) isNotStartedOnly returns (uint) {\n', '        uint i = 0;\n', '        while (i < dests.length) {\n', '           mint(dests[i], values[i]);\n', '           i += 1;\n', '        }\n', '        return(i);\n', '    }\n', '}\n', '\n', 'contract TokenWithoutStart is Owned {\n', '    using SafeMath for uint;\n', '\n', '    mapping (address => uint) balances;\n', '    mapping (address => mapping (address => uint)) allowed;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint public totalSupply;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '\n', '    function TokenWithoutStart(string _name, string _symbol, uint8 _decimals) public {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '    }\n', '\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '        require(_to != address(0));\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {\n', '        require(_to != address(0));\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve_fixed(address _spender, uint _currentValue, uint _value) public returns (bool success) {\n', '        if(allowed[msg.sender][_spender] == _currentValue){\n', '            allowed[msg.sender][_spender] = _value;\n', '            emit Approval(msg.sender, _spender, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function approve(address _spender, uint _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function mint(address _to, uint _amount) public only(owner) returns(bool) {\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    function multimint(address[] dests, uint[] values) public only(owner) returns (uint) {\n', '        uint i = 0;\n', '        while (i < dests.length) {\n', '           mint(dests[i], values[i]);\n', '           i += 1;\n', '        }\n', '        return(i);\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '//This contract is used to distribute tokens reserved for Jury.Online team the terms of distirbution are following:\n', '//after the end of ICO tokens are frozen for 6 months and afterwards each months 10% of tokens is unfrozen\n', '\n', 'contract Vesting {\n', '\n', '    //1. Alexander Shevtsov            0x4C67EB86d70354731f11981aeE91d969e3823c39\n', '    //2. Anastasia Bormotova           0x450Eb50Cc83B155cdeA8b6d47Be77970Cf524368\n', '    //3. Artemiy Pirozhkov             0x9CFf3408a1eB46FE1F9de91f932FDCfEC34A568f\n', '    //4. Konstantin Kudryavtsev        0xA14d9fa5B1b46206026eA51A98CeEd182A91a190\n', '    //5. Marina Kobyakova              0x0465f2fA674bF20Fe9484dB70D8570617495b352\n', '    //6. Nikita Alekseev               0x07F8a6Fb0Ad63abBe21e8ef33523D8368618cd10\n', '    //7. Nikolay Prudnikov             0xF29fE8e258b084d40D9cF1dCF02E5CB29837b6D5\n', '    //8. Valeriy Strechen              0x64B557EaED227B841DcEd9f70918cd8f5ca2Bdab\n', '    //9. Igor Lavrenov                 0x05d1e624eaDF70bb7F8A2B11D39A8a5635e5D007\n', '    \n', '    uint public constant interval = 30 days;\n', '    uint public constant distributionStart = 1540994400; //1st of November\n', '    uint public currentStage;\n', '    uint public stageAmount;\n', '    uint public toSendLeft;\n', '\n', '    address[] public team;\n', '    Token public token;\n', '\n', '    constructor(address[] _team, address _token) {\n', '        token = Token(_token);\n', '        for(uint i=0; i<_team.length; i++) {\n', '            team.push(_team[i]);\n', '        }\n', '    }\n', '\n', '    function makePayouts() {\n', '        require(toSendLeft != 0);\n', '        if (now > interval*currentStage + distributionStart) {\n', '\t\t\tuint balance = stageAmount/team.length;\n', '            for(uint i=0; i<team.length; i++) {\n', '                toSendLeft -= balance;\n', '                require(token.transfer(team[i], balance));\n', '            }\n', '        currentStage+=1;\n', '        }\n', '    }\n', '\n', '    function setToSendLeft() {\n', '        require(toSendLeft == 0);\n', '        toSendLeft = token.balanceOf(address(this));\n', '        stageAmount = toSendLeft/10;\n', '    }\n', '\n', '\n', '\n', '}']
