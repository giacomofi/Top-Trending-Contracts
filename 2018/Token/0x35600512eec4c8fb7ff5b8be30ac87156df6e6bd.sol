['pragma solidity ^0.4.23;\n', '\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '  address public manager;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '  event SetManager(address indexed _manager);\n', '\n', '  constructor () public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '  \n', '  modifier onlyManager() {\n', '      require(msg.sender == manager);\n', '      _;\n', '  }\n', '  \n', '  function setManager(address _manager)public onlyOwner returns (bool) {\n', '      manager = _manager;\n', '      return true;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', 'contract BasicBF is Pausable {\n', '    using SafeMath for uint256;\n', '    \n', '    mapping (address => uint256) public balances;\n', '    // match -> team -> amount\n', '    mapping (uint256 => mapping (uint256 => uint256)) public betMatchBalances;\n', '    // match -> team -> user -> amount\n', '    mapping (uint256 => mapping (uint256 => mapping (address => uint256))) public betMatchRecords;\n', '\n', '    event Withdraw(address indexed user, uint256 indexed amount);\n', '    event WithdrawOwner(address indexed user, uint256 indexed amount);\n', '    event Issue(address indexed user, uint256 indexed amount);\n', '    event BetMatch(address indexed user, uint256 indexed matchNo, uint256 indexed teamNo, uint256 amount);\n', '    event BehalfBet(address indexed user, uint256 indexed matchNo, uint256 indexed teamNo, uint256 amount);\n', '}\n', '\n', 'contract BF is BasicBF {\n', '    constructor () public {}\n', '    \n', '    function betMatch(uint256 _matchNo, uint256 _teamNo) public whenNotPaused payable returns (bool) {\n', '        uint256 amount = msg.value;\n', '        betMatchRecords[_matchNo][_teamNo][msg.sender] = betMatchRecords[_matchNo][_teamNo][msg.sender].add(amount);\n', '        betMatchBalances[_matchNo][_teamNo] = betMatchBalances[_matchNo][_teamNo].add(amount);\n', '        balances[this] = balances[this].add(amount);\n', '        emit BetMatch(msg.sender, _matchNo, _teamNo, amount);\n', '        return true;\n', '    }\n', '    \n', '    function behalfBet(address _user, uint256 _matchNo, uint256 _teamNo) public whenNotPaused onlyManager payable returns (bool) {\n', '        uint256 amount = msg.value;\n', '        betMatchRecords[_matchNo][_teamNo][_user] = betMatchRecords[_matchNo][_teamNo][_user].add(amount);\n', '        betMatchBalances[_matchNo][_teamNo] = betMatchBalances[_matchNo][_teamNo].add(amount);\n', '        balances[this] = balances[this].add(amount);\n', '        emit BehalfBet(_user, _matchNo, _teamNo, amount);\n', '        return true;\n', '    }\n', '    \n', '    function issue(address[] _addrLst, uint256[] _amtLst) public whenNotPaused onlyManager returns (bool) {\n', '        require(_addrLst.length == _amtLst.length);\n', '        for (uint i=0; i<_addrLst.length; i++) {\n', '            balances[_addrLst[i]] = balances[_addrLst[i]].add(_amtLst[i]);\n', '            balances[this] = balances[this].sub(_amtLst[i]);\n', '            emit Issue(_addrLst[i], _amtLst[i]);\n', '        }\n', '        return true;\n', '    }\n', '    \n', '    function withdraw(uint256 _value) public whenNotPaused returns (bool) {\n', '        require(_value <= balances[msg.sender]);\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        msg.sender.transfer(_value);\n', '        emit Withdraw(msg.sender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function withdrawOwner(uint256 _value) public onlyManager returns (bool) {\n', '        require(_value <= balances[this]);\n', '        balances[this] = balances[this].sub(_value);\n', '        msg.sender.transfer(_value);\n', '        emit WithdrawOwner(msg.sender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function () public payable {}\n', '}']
['pragma solidity ^0.4.23;\n', '\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '  address public manager;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '  event SetManager(address indexed _manager);\n', '\n', '  constructor () public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '  \n', '  modifier onlyManager() {\n', '      require(msg.sender == manager);\n', '      _;\n', '  }\n', '  \n', '  function setManager(address _manager)public onlyOwner returns (bool) {\n', '      manager = _manager;\n', '      return true;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', 'contract BasicBF is Pausable {\n', '    using SafeMath for uint256;\n', '    \n', '    mapping (address => uint256) public balances;\n', '    // match -> team -> amount\n', '    mapping (uint256 => mapping (uint256 => uint256)) public betMatchBalances;\n', '    // match -> team -> user -> amount\n', '    mapping (uint256 => mapping (uint256 => mapping (address => uint256))) public betMatchRecords;\n', '\n', '    event Withdraw(address indexed user, uint256 indexed amount);\n', '    event WithdrawOwner(address indexed user, uint256 indexed amount);\n', '    event Issue(address indexed user, uint256 indexed amount);\n', '    event BetMatch(address indexed user, uint256 indexed matchNo, uint256 indexed teamNo, uint256 amount);\n', '    event BehalfBet(address indexed user, uint256 indexed matchNo, uint256 indexed teamNo, uint256 amount);\n', '}\n', '\n', 'contract BF is BasicBF {\n', '    constructor () public {}\n', '    \n', '    function betMatch(uint256 _matchNo, uint256 _teamNo) public whenNotPaused payable returns (bool) {\n', '        uint256 amount = msg.value;\n', '        betMatchRecords[_matchNo][_teamNo][msg.sender] = betMatchRecords[_matchNo][_teamNo][msg.sender].add(amount);\n', '        betMatchBalances[_matchNo][_teamNo] = betMatchBalances[_matchNo][_teamNo].add(amount);\n', '        balances[this] = balances[this].add(amount);\n', '        emit BetMatch(msg.sender, _matchNo, _teamNo, amount);\n', '        return true;\n', '    }\n', '    \n', '    function behalfBet(address _user, uint256 _matchNo, uint256 _teamNo) public whenNotPaused onlyManager payable returns (bool) {\n', '        uint256 amount = msg.value;\n', '        betMatchRecords[_matchNo][_teamNo][_user] = betMatchRecords[_matchNo][_teamNo][_user].add(amount);\n', '        betMatchBalances[_matchNo][_teamNo] = betMatchBalances[_matchNo][_teamNo].add(amount);\n', '        balances[this] = balances[this].add(amount);\n', '        emit BehalfBet(_user, _matchNo, _teamNo, amount);\n', '        return true;\n', '    }\n', '    \n', '    function issue(address[] _addrLst, uint256[] _amtLst) public whenNotPaused onlyManager returns (bool) {\n', '        require(_addrLst.length == _amtLst.length);\n', '        for (uint i=0; i<_addrLst.length; i++) {\n', '            balances[_addrLst[i]] = balances[_addrLst[i]].add(_amtLst[i]);\n', '            balances[this] = balances[this].sub(_amtLst[i]);\n', '            emit Issue(_addrLst[i], _amtLst[i]);\n', '        }\n', '        return true;\n', '    }\n', '    \n', '    function withdraw(uint256 _value) public whenNotPaused returns (bool) {\n', '        require(_value <= balances[msg.sender]);\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        msg.sender.transfer(_value);\n', '        emit Withdraw(msg.sender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function withdrawOwner(uint256 _value) public onlyManager returns (bool) {\n', '        require(_value <= balances[this]);\n', '        balances[this] = balances[this].sub(_value);\n', '        msg.sender.transfer(_value);\n', '        emit WithdrawOwner(msg.sender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function () public payable {}\n', '}']
