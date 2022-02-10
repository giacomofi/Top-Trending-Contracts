['pragma solidity 0.4.22;\n', '\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public view returns (uint);\n', '    function balanceOf(address tokenOwner) public view returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '    event FrozenFunds(address target, uint tokens);\n', '    event Buy(address indexed sender, uint eth, uint token);\n', '}\n', '\n', '// Owned contract\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    //Transfer owner rights, can use only owner (the best practice of secure for the contracts)\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    //Accept tranfer owner rights\n', '    function acceptOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '// Pausable Contract\n', 'contract Pausable is Owned {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '  //Modifier to make a function callable only when the contract is not paused.\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '\n', '  //Modifier to make a function callable only when the contract is paused.\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  //called by the owner to pause, triggers stopped state\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  //called by the owner to unpause, returns to normal state\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', 'contract VXR is ERC20Interface, Pausable {\n', '    using SafeMath for uint;\n', '    string public symbol;\n', '    string public  name;\n', '    uint8 public decimals;\n', '\n', '    uint public _totalSupply;\n', '    mapping(address => uint) public balances;\n', '    mapping(address => uint) public lockInfo;\n', '    mapping(address => mapping(address => uint)) internal allowed;\n', '    mapping (address => bool) public admins;\n', '    \n', '    modifier onlyAdmin {\n', '        require(msg.sender == owner || admins[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    function setAdmin(address _admin, bool isAdmin) public onlyOwner {\n', '        admins[_admin] = isAdmin;\n', '    }\n', '\n', '    constructor() public{\n', '        symbol = &#39;VXR&#39;;\n', '        name = &#39;Versara Trade&#39;;\n', '        decimals = 18;\n', '        _totalSupply = 1000000000*10**uint(decimals);\n', '        balances[owner] = _totalSupply;\n', '        emit Transfer(address(0), owner, _totalSupply);\n', '    }\n', '\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != 0x0);                                    // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_value != 0);                                   // Prevent transfer 0\n', '        require(balances[_from] >= _value);                     // Check if the sender has enough\n', '        require(balances[_from] - _value >= lockInfo[_from]);   // Check after transaction, balance is still more than locked value\n', '        balances[_from] = balances[_from].sub(_value);          // Substract value from sender\n', '        balances[_to] = balances[_to].add(_value);              // Add value to recipient\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function transfer(address to, uint tokens) public whenNotPaused returns (bool success) {\n', '         _transfer(msg.sender, to, tokens);\n', '         return true;\n', '    }\n', '\n', '    function approve(address _spender, uint tokens) public whenNotPaused returns (bool success) {\n', '        allowed[msg.sender][_spender] = tokens;\n', '        emit Approval(msg.sender, _spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool success) {\n', '        require(allowed[from][msg.sender] >= tokens);\n', '        _transfer(from, to, tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address tokenOwner, address spender) public whenNotPaused view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '    \n', '    //Admin Tool\n', '    function lockOf(address tokenOwner) public view returns (uint lockedToken) {\n', '        return lockInfo[tokenOwner];\n', '    }\n', '\n', '    //lock tokens or lock 0 to release all\n', '    function lock(address target, uint lockedToken) public whenNotPaused onlyAdmin {\n', '        lockInfo[target] = lockedToken;\n', '        emit FrozenFunds(target, lockedToken);\n', '    }\n', '\n', '    //Batch lock or lock 0 to release all\n', '    function batchLock(address[] accounts, uint lockedToken) public whenNotPaused onlyAdmin {\n', '      for (uint i = 0; i < accounts.length; i++) {\n', '           lock(accounts[i], lockedToken);\n', '        }\n', '    }\n', '\n', '    //Batch lock amount with array\n', '    function batchLockArray(address[] accounts, uint[] lockedToken) public whenNotPaused onlyAdmin {\n', '      for (uint i = 0; i < accounts.length; i++) {\n', '           lock(accounts[i], lockedToken[i]);\n', '        }\n', '    }\n', '\n', '    //Airdrop Batch with lock \n', '    function batchAirdropWithLock(address[] receivers, uint tokens, bool freeze) public whenNotPaused onlyAdmin {\n', '      for (uint i = 0; i < receivers.length; i++) {\n', '           sendTokensWithLock(receivers[i], tokens, freeze);\n', '        }\n', '    }\n', '\n', '    //VIP Batch with lock\n', '    function batchVipWithLock(address[] receivers, uint[] tokens, bool freeze) public whenNotPaused onlyAdmin {\n', '      for (uint i = 0; i < receivers.length; i++) {\n', '           sendTokensWithLock(receivers[i], tokens[i], freeze);\n', '        }\n', '    }\n', '\n', '    //Send token with lock \n', '    function sendTokensWithLock (address receiver, uint tokens, bool freeze) public whenNotPaused onlyAdmin {\n', '        _transfer(msg.sender, receiver, tokens);\n', '        if(freeze) {\n', '            uint lockedAmount = lockInfo[receiver] + tokens;\n', '            lock(receiver, lockedAmount);\n', '        }\n', '    }\n', '\n', '    //Send initial tokens\n', '    function sendInitialTokens (address user) public onlyOwner {\n', '        _transfer(msg.sender, user, balanceOf(owner));\n', '    }\n', '}']