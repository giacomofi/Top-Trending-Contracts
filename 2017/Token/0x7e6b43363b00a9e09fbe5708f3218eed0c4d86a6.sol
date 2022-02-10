['contract Token {\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract StandardToken is Token {\n', '\n', '    uint256 constant MAX_UINT256 = 2**256 - 1;\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        uint256 allowance = allowed[_from][msg.sender];\n', '        require(balances[_from] >= _value && allowance >= _value);\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '        if (allowance < MAX_UINT256) {\n', '            allowed[_from][msg.sender] -= _value;\n', '        }\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) view public returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) view public returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract ERC223ReceivingContract {\n', '/**\n', ' * @dev Standard ERC223 function that will handle incoming token transfers.\n', ' *\n', ' * @param _from  Token sender address.\n', ' * @param _value Amount of tokens.\n', ' * @param _data  Transaction metadata.\n', ' */\n', '    function tokenFallback(address _from, uint _value, bytes _data) public;\n', '}\n', '\n', 'contract ERC223Interface {\n', '    function transfer(address _to, uint _value) public returns (bool success);\n', '    function transfer(address _to, uint _value, bytes _data) public returns (bool success);\n', '    event ERC223Transfer(address indexed _from, address indexed _to, uint _value, bytes _data);\n', '}\n', '\n', 'contract HumanStandardToken is ERC223Interface, StandardToken {\n', '    using SafeMath for uint256;\n', '\n', '    /* approveAndCall */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '\n', "        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.\n", '        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)\n', '        //it is assumed when one does this that the call *should* succeed, otherwise one would use vanilla approve instead.\n', '        require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));\n', '        return true;\n', '    }\n', '\n', '    /* ERC223 */\n', '    function transfer(address _to, uint _value, bytes _data) public returns (bool success) {\n', '      // Standard function transfer similar to ERC20 transfer with no _data .\n', '      // Added due to backwards compatibility reasons .\n', '      uint codeLength;\n', '\n', '      assembly {\n', '        // Retrieve the size of the code on target address, this needs assembly .\n', '        codeLength := extcodesize(_to)\n', '      }\n', '\n', '      balances[msg.sender] = balances[msg.sender].sub(_value);\n', '      balances[_to] = balances[_to].add(_value);\n', '      if(codeLength>0) {\n', '        ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '        receiver.tokenFallback(msg.sender, _value, _data);\n', '      }\n', '      Transfer(msg.sender, _to, _value);\n', '      ERC223Transfer(msg.sender, _to, _value, _data);\n', '      return true;\n', '    }\n', '\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '        uint codeLength;\n', '        bytes memory empty;\n', '\n', '        assembly {\n', '            // Retrieve the size of the code on target address, this needs assembly .\n', '            codeLength := extcodesize(_to)\n', '        }\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        if(codeLength>0) {\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '            receiver.tokenFallback(msg.sender, _value, empty);\n', '        }\n', '        Transfer(msg.sender, _to, _value);\n', '        ERC223Transfer(msg.sender, _to, _value, empty);\n', '        return true;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract LunetToken is HumanStandardToken {\n', '    using SafeMath for uint256;\n', '\n', '    string public name = "Lunet";\n', '    string public symbol= "LUNET";\n', '    uint8 public decimals = 18;\n', '\n', '    uint256 public tokenCreationCap = 1000000000000000000000000000; // 1 billion LUNETS\n', '    uint256 public lunetReserve = 50000000000000000000000000; // 50 million LUNETS - 5% of LUNETS\n', '\n', '    event CreateLUNETS(address indexed _to, uint256 _value, uint256 _timestamp);\n', '    event Staked(address indexed _from, uint256 _value, uint256 _timestamp);\n', '    event Withdraw(address indexed _from, uint256 _value, uint256 _timestamp);\n', '\n', '    struct Stake {\n', '      uint256 amount;\n', '      uint256 timestamp;\n', '    }\n', '\n', '    mapping (address => Stake) public stakes;\n', '\n', '    function LunetToken() public {\n', '       totalSupply = lunetReserve;\n', '       balances[msg.sender] = lunetReserve;\n', '       CreateLUNETS(msg.sender, lunetReserve, now);\n', '    }\n', '\n', '    function stake() external payable {\n', '      require(msg.value > 0);\n', '\n', '      // get stake\n', '      Stake storage stake = stakes[msg.sender];\n', '\n', '      uint256 amount = stake.amount.add(msg.value);\n', '\n', '      // update stake\n', '      stake.amount = amount;\n', '      stake.timestamp = now;\n', '\n', '      // fire off stake event\n', '      Staked(msg.sender, amount, now);\n', '    }\n', '\n', '    function withdraw() public {\n', '      // get stake\n', '      Stake storage stake = stakes[msg.sender];\n', '\n', '      // check the stake is non-zero\n', '      require(stake.amount > 0);\n', '\n', '      // copy amount\n', '      uint256 amount = stake.amount;\n', '\n', '      // reset stake amount\n', '      stake.amount = 0;\n', '\n', '      // send amount to staker\n', '      if (!msg.sender.send(amount)) revert();\n', '\n', '      // fire off withdraw event\n', '      Withdraw(msg.sender, amount, now);\n', '    }\n', '\n', '    function claim() public {\n', '      // get reward\n', '      uint256 reward = getReward(msg.sender);\n', '\n', '      // check that the reward is non-zero\n', '      if (reward > 0) {\n', '        // reset the timestamp\n', '        Stake storage stake = stakes[msg.sender];\n', '        stake.timestamp = now;\n', '\n', '        uint256 checkedSupply = totalSupply.add(reward);\n', '        if (tokenCreationCap < checkedSupply) revert();\n', '\n', '        // update totalSupply of LUNETS\n', '        totalSupply = checkedSupply;\n', '\n', '        // update LUNETS balance\n', '        balances[msg.sender] += reward;\n', '\n', '        // create LUNETS\n', '        CreateLUNETS(msg.sender, reward, now);\n', '      }\n', '\n', '    }\n', '\n', '    function claimAndWithdraw() external {\n', '      claim();\n', '      withdraw();\n', '    }\n', '\n', '    function getReward(address staker) public constant returns (uint256) {\n', '      // get stake\n', '      Stake memory stake = stakes[staker];\n', '\n', '      // need greater precision\n', '      uint256 precision = 100000;\n', '\n', '      // get difference between now and initial stake timestamp\n', '      uint256 difference = now.sub(stake.timestamp).mul(precision);\n', '\n', '      // get the total number of days ETH has been locked up\n', '      uint totalDays = difference.div(1 days);\n', '\n', '      // calculate reward\n', '      uint256 reward = stake.amount.mul(totalDays).div(precision);\n', '\n', '      return reward;\n', '    }\n', '\n', '    function getStake(address staker) external constant returns (uint256, uint256) {\n', '      Stake memory stake = stakes[staker];\n', '      return (stake.amount, stake.timestamp);\n', '    }\n', '}']