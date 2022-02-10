['pragma solidity ^0.4.17;\n', '\n', '\n', 'contract Token {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract SafeMath {\n', '  function safeMult(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeSubtract(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control \n', ' * functions, this simplifies the implementation of "user permissions". \n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '  /** \n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = 0x87184e997983e3470b50f92a45e6e677cd93c299;\n', '  }\n', '  /**\n', '   * @dev Throws if called by any account other than the owner. \n', '   */\n', '  modifier onlyOwner() {\n', '    assert (msg.sender == owner);\n', '    _;\n', '  }\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to. \n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '  bool public paused = true;\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS paused\n', '   */\n', '  modifier whenNotPaused() {\n', '    assert(paused!=true);\n', '    _;\n', '  }\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS NOT paused\n', '   */\n', '  modifier whenPaused {\n', '    assert(paused==true);\n', '    _;\n', '  }\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public returns (bool) {\n', '    paused = true;\n', '    Pause();\n', '    return true;\n', '  }\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public returns (bool) {\n', '    paused = false;\n', '    Unpause();\n', '    return true;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ethPausable\n', ' */\n', 'contract ethPausable is Ownable {\n', '  event ethPause();\n', '  event ethUnpause();\n', '  bool public ethpaused = true;\n', '  modifier ethwhenNotPaused() {\n', '    assert(ethpaused!=true);\n', '    _;\n', '  }\n', '  modifier ethwhenPaused {\n', '    assert(ethpaused==true);\n', '    _;\n', '  }\n', '  function ethpause() public onlyOwner ethwhenNotPaused returns (bool) {\n', '    ethpaused = true;\n', '    ethPause();\n', '    return true;\n', '  }\n', '  function ethunpause() public onlyOwner ethwhenPaused returns (bool) {\n', '    ethpaused = false;\n', '    ethUnpause();\n', '    return true;\n', '  }\n', '}\n', '\n', '/*  ERC 20 token */\n', 'contract StandardToken is Token, Pausable{\n', '    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success) {\n', '      if (balances[msg.sender] >= _value && _value > 0) {\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '      } else {\n', '        return false;\n', '      }\n', '    }\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {\n', '      if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '        allowed[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '      } else {\n', '        return false;\n', '      }\n', '    }\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract GraceCoin is StandardToken, SafeMath, ethPausable {\n', '    string public constant name = "Grace Coin";\n', '    string public constant symbol = "GRACE";\n', '    uint256 public constant decimals = 8;\n', '    string public version = "1.0";\n', '    address public G2UFundDeposit;\n', '    address public ETHFundDeposit;\n', '    address public GraceFund;\n', '    uint256 public constant G2Ufund = 6300*10000*10**decimals;\n', '    uint256 public buyExchangeRate = 1*10**8; // per 1 ETH buy 1 Grace Coin  \n', '    uint256 public sellExchangeRate = 1*10**8; // per 1 Grace Coin buy 1 ETH\n', '    uint256 public constant ETHfund= 2100*10000*10**decimals;\n', '    event LogRefund(address indexed _to, uint256 _value);\n', '    event CreateBAT(address indexed _to, uint256 _value);\n', '    function GraceCoin() public{\n', '      G2UFundDeposit = 0xf03d707298c78c4504ba7da5aedf52f18e7b7d95;\n', '      ETHFundDeposit = 0xfd9af334d2428a56f1a96fa45c37f6b89ec6a307;\n', '      totalSupply = G2Ufund+ETHfund;\n', '      balances[G2UFundDeposit] = G2Ufund;\n', '      balances[ETHFundDeposit] = ETHfund;\n', '      CreateBAT(G2UFundDeposit, G2Ufund);\n', '    }\n', '    function setBuyExchangeRate(uint rate) public returns(uint){\n', '        assert(msg.sender==owner);\n', '        buyExchangeRate = rate;\n', '        return rate;\n', '    }\n', '    function setSellExchangeRate(uint rate) public returns(uint){\n', '        assert(msg.sender==owner);\n', '        sellExchangeRate = rate;\n', '        return rate;\n', '    }\n', '    function buyCoins() ethwhenNotPaused payable external {\n', '        uint256 tokens = safeMult(msg.value, buyExchangeRate)/(10**18); \n', '        assert(balances[ETHFundDeposit]>=tokens);\n', '        balances[ETHFundDeposit] -= tokens;\n', '        balances[msg.sender] += tokens;\n', '        Transfer(ETHFundDeposit, msg.sender, tokens);\n', '    }\n', '    function sellCoins(uint G2Uamount) ethwhenNotPaused payable external {\n', '        assert(balances[msg.sender] >= G2Uamount);\n', '        uint256 etherAmount = safeMult(G2Uamount,sellExchangeRate)*100;\n', '        assert(etherAmount <= this.balance);\n', '        msg.sender.transfer(etherAmount);\n', '        balances[msg.sender] = safeSubtract(balances[msg.sender],G2Uamount);\n', '        Transfer(msg.sender, ETHFundDeposit, G2Uamount);\n', '    }\n', '    function getBalance() public constant returns(uint){\n', '        return this.balance;  \n', '    }\n', '    function getEther (uint balancesNum) public{\n', '        assert(msg.sender == G2UFundDeposit);\n', '        assert(balancesNum <= this.balance);\n', '        G2UFundDeposit.transfer(balancesNum);\n', '    }\n', '    function putEther() public payable returns(bool){\n', '        return true;\n', '    }\n', '    function graceTransfer(address _to, uint256 _value) public returns (bool success) {\n', '      assert(msg.sender==G2UFundDeposit||msg.sender==ETHFundDeposit||msg.sender==owner);\n', '      if (balances[msg.sender] >= _value && _value > 0) {\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '      } else {\n', '        return false;\n', '      }\n', '    }\n', '\n', '}']