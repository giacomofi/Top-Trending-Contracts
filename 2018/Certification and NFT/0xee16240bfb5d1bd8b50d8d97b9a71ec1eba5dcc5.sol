['pragma solidity ^0.4.18;\n', '\n', '// accepted from zeppelin-solidity https://github.com/OpenZeppelin/zeppelin-solidity\n', '/*\n', ' * ERC20 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '  uint public totalSupply;\n', '  function balanceOf(address _who) public constant returns (uint);\n', '  function allowance(address _owner, address _spender) public constant returns (uint);\n', '\n', '  function transfer(address _to, uint _value) public returns (bool ok);\n', '  function transferFrom(address _from, address _to, uint _value) public returns (bool ok);\n', '  function approve(address _spender, uint _value) public returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'contract SafeMath {\n', '  function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract VLToken is ERC20, Ownable, SafeMath {\n', '\n', '    // Token related informations\n', '    string public constant name = "Villiam Blockchain Token";\n', '    string public constant symbol = "VLT";\n', '    uint256 public constant decimals = 18; // decimal places\n', '\n', '    // Start withdraw of tokens\n', '    uint256 public startWithdraw;\n', '\n', '    // Address of wallet from which tokens assigned\n', '    address public ethExchangeWallet;\n', '\n', '    // MultiSig Wallet Address\n', '    address public VLTMultisig;\n', '\n', '    uint256 public tokensPerEther = 1500;\n', '\n', '    bool public startStop = false;\n', '\n', '    mapping (address => uint256) public walletAngelSales;\n', '    mapping (address => uint256) public walletPESales;\n', '\n', '    mapping (address => uint256) public releasedAngelSales;\n', '    mapping (address => uint256) public releasedPESales;\n', '\n', '    mapping (uint => address) public walletAddresses;\n', '\n', '    // Mapping of token balance and allowed address for each address with transfer limit\n', '    mapping (address => uint256) balances;\n', '    //mapping of allowed address for each address with tranfer limit\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    function VLToken() public {\n', '        totalSupply = 500000000 ether;\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '\n', '    // Only to be called by Owner of this contract\n', '    // @param _id Id of lock wallet address\n', '    // @param _walletAddress Address of lock wallet\n', '    function addWalletAddresses(uint _id, address _walletAddress) onlyOwner external{\n', '        require(_walletAddress != address(0));\n', '        walletAddresses[_id] = _walletAddress;\n', '    }\n', '\n', '    // Owner can Set Multisig wallet\n', '    // @param _vltMultisig address of Multisig wallet.\n', '    function setVLTMultiSig(address _vltMultisig) onlyOwner external{\n', '        require(_vltMultisig != address(0));\n', '        VLTMultisig = _vltMultisig;\n', '    }\n', '\n', '    // Only to be called by Owner of this contract\n', '    // @param _ethExchangeWallet Ether Address of exchange wallet\n', '    function setEthExchangeWallet(address _ethExchangeWallet) onlyOwner external {\n', '        require(_ethExchangeWallet != address(0));\n', '        ethExchangeWallet = _ethExchangeWallet;\n', '    }\n', '\n', '    // Only to be called by Owner of this contract\n', '    // @param _tokensPerEther Tokens per ether during ICO stages\n', '    function setTokensPerEther(uint256 _tokensPerEther) onlyOwner external {\n', '        require(_tokensPerEther > 0);\n', '        tokensPerEther = _tokensPerEther;\n', '    }\n', '\n', '    function startStopICO(bool status) onlyOwner external {\n', '        startStop = status;\n', '    }\n', '\n', '    function startLockingPeriod() onlyOwner external {\n', '        startWithdraw = now;\n', '    }\n', '\n', '    // Assign tokens to investor with locking period\n', '    function assignToken(address _investor,uint256 _tokens) external {\n', '        // Tokens assigned by only Angel Sales And PE Sales wallets\n', '        require(msg.sender == walletAddresses[0] || msg.sender == walletAddresses[1]);\n', '\n', '        // Check investor address and tokens.Not allow 0 value\n', '        require(_investor != address(0) && _tokens > 0);\n', '        // Check wallet have enough token balance to assign\n', '        require(_tokens <= balances[msg.sender]);\n', '        \n', '        // Debit the tokens from the wallet\n', '        balances[msg.sender] = safeSub(balances[msg.sender],_tokens);\n', '\n', '        uint256 calCurrentTokens = getPercentageAmount(_tokens, 20);\n', '        uint256 allocateTokens = safeSub(_tokens, calCurrentTokens);\n', '\n', '        // Initially assign 20% tokens to the investor\n', '        balances[_investor] = safeAdd(balances[_investor], calCurrentTokens);\n', '\n', '        // Assign tokens to the investor\n', '        if(msg.sender == walletAddresses[0]){\n', '            walletAngelSales[_investor] = safeAdd(walletAngelSales[_investor],allocateTokens);\n', '            releasedAngelSales[_investor] = safeAdd(releasedAngelSales[_investor], calCurrentTokens);\n', '        }\n', '        else if(msg.sender == walletAddresses[1]){\n', '            walletPESales[_investor] = safeAdd(walletPESales[_investor],allocateTokens);\n', '            releasedPESales[_investor] = safeAdd(releasedPESales[_investor], calCurrentTokens);\n', '        }\n', '        else{\n', '            revert();\n', '        }\n', '    }\n', '\n', '    function withdrawTokens() public {\n', '        require(walletAngelSales[msg.sender] > 0 || walletPESales[msg.sender] > 0);\n', '        uint256 withdrawableAmount = 0;\n', '\n', '        if (walletAngelSales[msg.sender] > 0) {\n', '            uint256 withdrawableAmountAS = getWithdrawableAmountAS(msg.sender);\n', '            walletAngelSales[msg.sender] = safeSub(walletAngelSales[msg.sender], withdrawableAmountAS);\n', '            releasedAngelSales[msg.sender] = safeAdd(releasedAngelSales[msg.sender],withdrawableAmountAS);\n', '            withdrawableAmount = safeAdd(withdrawableAmount, withdrawableAmountAS);\n', '        }\n', '        if (walletPESales[msg.sender] > 0) {\n', '            uint256 withdrawableAmountPS = getWithdrawableAmountPES(msg.sender);\n', '            walletPESales[msg.sender] = safeSub(walletPESales[msg.sender], withdrawableAmountPS);\n', '            releasedPESales[msg.sender] = safeAdd(releasedPESales[msg.sender], withdrawableAmountPS);\n', '            withdrawableAmount = safeAdd(withdrawableAmount, withdrawableAmountPS);\n', '        }\n', '        require(withdrawableAmount > 0);\n', '        // Assign tokens to the sender\n', '        balances[msg.sender] = safeAdd(balances[msg.sender], withdrawableAmount);\n', '    }\n', '\n', '    // For wallet Angel Sales\n', '    function getWithdrawableAmountAS(address _investor) public view returns(uint256) {\n', '        require(startWithdraw != 0);\n', '        // interval in months\n', '        uint interval = safeDiv(safeSub(now,startWithdraw),30 days);\n', '        // total allocatedTokens\n', '        uint _allocatedTokens = safeAdd(walletAngelSales[_investor],releasedAngelSales[_investor]);\n', '        // Atleast 6 months\n', '        if (interval < 6) { \n', '            return (0); \n', '        } else if (interval >= 6 && interval < 9) {\n', '            return safeSub(getPercentageAmount(40,_allocatedTokens), releasedAngelSales[_investor]);\n', '        } else if (interval >= 9 && interval < 12) {\n', '            return safeSub(getPercentageAmount(60,_allocatedTokens), releasedAngelSales[_investor]);\n', '        } else if (interval >= 12 && interval < 15) {\n', '            return safeSub(getPercentageAmount(80,_allocatedTokens), releasedAngelSales[_investor]);\n', '        } else if (interval >= 15) {\n', '            return safeSub(_allocatedTokens, releasedAngelSales[_investor]);\n', '        }\n', '    }\n', '\n', '    // For wallet PE Sales\n', '    function getWithdrawableAmountPES(address _investor) public view returns(uint256) {\n', '        require(startWithdraw != 0);\n', '        // interval in months\n', '        uint interval = safeDiv(safeSub(now,startWithdraw),30 days);\n', '        // total allocatedTokens\n', '        uint _allocatedTokens = safeAdd(walletPESales[_investor],releasedPESales[_investor]);\n', '        // Atleast 12 months\n', '        if (interval < 12) { \n', '            return (0); \n', '        } else if (interval >= 12 && interval < 18) {\n', '            return safeSub(getPercentageAmount(40,_allocatedTokens), releasedPESales[_investor]);\n', '        } else if (interval >= 18 && interval < 24) {\n', '            return safeSub(getPercentageAmount(60,_allocatedTokens), releasedPESales[_investor]);\n', '        } else if (interval >= 24 && interval < 30) {\n', '            return safeSub(getPercentageAmount(80,_allocatedTokens), releasedPESales[_investor]);\n', '        } else if (interval >= 30) {\n', '            return safeSub(_allocatedTokens, releasedPESales[_investor]);\n', '        }\n', '    }\n', '\n', '    function getPercentageAmount(uint256 percent,uint256 _tokens) internal pure returns (uint256) {\n', '        return safeDiv(safeMul(_tokens,percent),100);\n', '    }\n', '\n', '    // Sale of the tokens. Investors can call this method to invest into VLT Tokens\n', '    function() payable external {\n', '        // Allow only to invest in ICO stage\n', '        require(startStop);\n', '\n', '        //Sorry !! We only allow to invest with minimum 0.5 Ether as value\n', '        require(msg.value >= (0.5 ether));\n', '\n', '        // multiply by exchange rate to get token amount\n', '        uint256 calculatedTokens = safeMul(msg.value, tokensPerEther);\n', '\n', '        // Wait we check tokens available for assign\n', '        require(balances[ethExchangeWallet] >= calculatedTokens);\n', '\n', '        // Call to Internal function to assign tokens\n', '        assignTokens(msg.sender, calculatedTokens);\n', '    }\n', '\n', '    // Function will transfer the tokens to investor&#39;s address\n', '    // Common function code for assigning tokens\n', '    function assignTokens(address investor, uint256 tokens) internal {\n', '        // Debit tokens from ether exchange wallet\n', '        balances[ethExchangeWallet] = safeSub(balances[ethExchangeWallet], tokens);\n', '\n', '        // Assign tokens to the sender\n', '        balances[investor] = safeAdd(balances[investor], tokens);\n', '\n', '        // Finally token assigned to sender, log the creation event\n', '        Transfer(ethExchangeWallet, investor, tokens);\n', '    }\n', '\n', '    function finalizeCrowdSale() external{\n', '        // Check VLT Multisig wallet set or not\n', '        require(VLTMultisig != address(0));\n', '        // Send fund to multisig wallet\n', '        require(VLTMultisig.send(address(this).balance));\n', '    }\n', '\n', '    // @param _who The address of the investor to check balance\n', '    // @return balance tokens of investor address\n', '    function balanceOf(address _who) public constant returns (uint) {\n', '        return balances[_who];\n', '    }\n', '\n', '    // @param _owner The address of the account owning tokens\n', '    // @param _spender The address of the account able to transfer the tokens\n', '    // @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) public constant returns (uint) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    //  Transfer `value` VLT tokens from sender&#39;s account\n', '    // `msg.sender` to provided account address `to`.\n', '    // @param _to The address of the recipient\n', '    // @param _value The number of VLT tokens to transfer\n', '    // @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint _value) public returns (bool ok) {\n', '        //validate receiver address and value.Not allow 0 value\n', '        require(_to != 0 && _value > 0);\n', '        uint256 senderBalance = balances[msg.sender];\n', '        //Check sender have enough balance\n', '        require(senderBalance >= _value);\n', '        senderBalance = safeSub(senderBalance, _value);\n', '        balances[msg.sender] = senderBalance;\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    //  Transfer `value` VLT tokens from sender &#39;from&#39;\n', '    // to provided account address `to`.\n', '    // @param from The address of the sender\n', '    // @param to The address of the recipient\n', '    // @param value The number of VLT to transfer\n', '    // @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool ok) {\n', '        //validate _from,_to address and _value(Now allow with 0)\n', '        require(_from != 0 && _to != 0 && _value > 0);\n', '        //Check amount is approved by the owner for spender to spent and owner have enough balances\n', '        require(allowed[_from][msg.sender] >= _value && balances[_from] >= _value);\n', '        balances[_from] = safeSub(balances[_from],_value);\n', '        balances[_to] = safeAdd(balances[_to],_value);\n', '        allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    //  `msg.sender` approves `spender` to spend `value` tokens\n', '    // @param spender The address of the account able to transfer the tokens\n', '    // @param value The amount of wei to be approved for transfer\n', '    // @return Whether the approval was successful or not\n', '    function approve(address _spender, uint _value) public returns (bool ok) {\n', '        //validate _spender address\n', '        require(_spender != 0);\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '// accepted from zeppelin-solidity https://github.com/OpenZeppelin/zeppelin-solidity\n', '/*\n', ' * ERC20 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '  uint public totalSupply;\n', '  function balanceOf(address _who) public constant returns (uint);\n', '  function allowance(address _owner, address _spender) public constant returns (uint);\n', '\n', '  function transfer(address _to, uint _value) public returns (bool ok);\n', '  function transferFrom(address _from, address _to, uint _value) public returns (bool ok);\n', '  function approve(address _spender, uint _value) public returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'contract SafeMath {\n', '  function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract VLToken is ERC20, Ownable, SafeMath {\n', '\n', '    // Token related informations\n', '    string public constant name = "Villiam Blockchain Token";\n', '    string public constant symbol = "VLT";\n', '    uint256 public constant decimals = 18; // decimal places\n', '\n', '    // Start withdraw of tokens\n', '    uint256 public startWithdraw;\n', '\n', '    // Address of wallet from which tokens assigned\n', '    address public ethExchangeWallet;\n', '\n', '    // MultiSig Wallet Address\n', '    address public VLTMultisig;\n', '\n', '    uint256 public tokensPerEther = 1500;\n', '\n', '    bool public startStop = false;\n', '\n', '    mapping (address => uint256) public walletAngelSales;\n', '    mapping (address => uint256) public walletPESales;\n', '\n', '    mapping (address => uint256) public releasedAngelSales;\n', '    mapping (address => uint256) public releasedPESales;\n', '\n', '    mapping (uint => address) public walletAddresses;\n', '\n', '    // Mapping of token balance and allowed address for each address with transfer limit\n', '    mapping (address => uint256) balances;\n', '    //mapping of allowed address for each address with tranfer limit\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    function VLToken() public {\n', '        totalSupply = 500000000 ether;\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '\n', '    // Only to be called by Owner of this contract\n', '    // @param _id Id of lock wallet address\n', '    // @param _walletAddress Address of lock wallet\n', '    function addWalletAddresses(uint _id, address _walletAddress) onlyOwner external{\n', '        require(_walletAddress != address(0));\n', '        walletAddresses[_id] = _walletAddress;\n', '    }\n', '\n', '    // Owner can Set Multisig wallet\n', '    // @param _vltMultisig address of Multisig wallet.\n', '    function setVLTMultiSig(address _vltMultisig) onlyOwner external{\n', '        require(_vltMultisig != address(0));\n', '        VLTMultisig = _vltMultisig;\n', '    }\n', '\n', '    // Only to be called by Owner of this contract\n', '    // @param _ethExchangeWallet Ether Address of exchange wallet\n', '    function setEthExchangeWallet(address _ethExchangeWallet) onlyOwner external {\n', '        require(_ethExchangeWallet != address(0));\n', '        ethExchangeWallet = _ethExchangeWallet;\n', '    }\n', '\n', '    // Only to be called by Owner of this contract\n', '    // @param _tokensPerEther Tokens per ether during ICO stages\n', '    function setTokensPerEther(uint256 _tokensPerEther) onlyOwner external {\n', '        require(_tokensPerEther > 0);\n', '        tokensPerEther = _tokensPerEther;\n', '    }\n', '\n', '    function startStopICO(bool status) onlyOwner external {\n', '        startStop = status;\n', '    }\n', '\n', '    function startLockingPeriod() onlyOwner external {\n', '        startWithdraw = now;\n', '    }\n', '\n', '    // Assign tokens to investor with locking period\n', '    function assignToken(address _investor,uint256 _tokens) external {\n', '        // Tokens assigned by only Angel Sales And PE Sales wallets\n', '        require(msg.sender == walletAddresses[0] || msg.sender == walletAddresses[1]);\n', '\n', '        // Check investor address and tokens.Not allow 0 value\n', '        require(_investor != address(0) && _tokens > 0);\n', '        // Check wallet have enough token balance to assign\n', '        require(_tokens <= balances[msg.sender]);\n', '        \n', '        // Debit the tokens from the wallet\n', '        balances[msg.sender] = safeSub(balances[msg.sender],_tokens);\n', '\n', '        uint256 calCurrentTokens = getPercentageAmount(_tokens, 20);\n', '        uint256 allocateTokens = safeSub(_tokens, calCurrentTokens);\n', '\n', '        // Initially assign 20% tokens to the investor\n', '        balances[_investor] = safeAdd(balances[_investor], calCurrentTokens);\n', '\n', '        // Assign tokens to the investor\n', '        if(msg.sender == walletAddresses[0]){\n', '            walletAngelSales[_investor] = safeAdd(walletAngelSales[_investor],allocateTokens);\n', '            releasedAngelSales[_investor] = safeAdd(releasedAngelSales[_investor], calCurrentTokens);\n', '        }\n', '        else if(msg.sender == walletAddresses[1]){\n', '            walletPESales[_investor] = safeAdd(walletPESales[_investor],allocateTokens);\n', '            releasedPESales[_investor] = safeAdd(releasedPESales[_investor], calCurrentTokens);\n', '        }\n', '        else{\n', '            revert();\n', '        }\n', '    }\n', '\n', '    function withdrawTokens() public {\n', '        require(walletAngelSales[msg.sender] > 0 || walletPESales[msg.sender] > 0);\n', '        uint256 withdrawableAmount = 0;\n', '\n', '        if (walletAngelSales[msg.sender] > 0) {\n', '            uint256 withdrawableAmountAS = getWithdrawableAmountAS(msg.sender);\n', '            walletAngelSales[msg.sender] = safeSub(walletAngelSales[msg.sender], withdrawableAmountAS);\n', '            releasedAngelSales[msg.sender] = safeAdd(releasedAngelSales[msg.sender],withdrawableAmountAS);\n', '            withdrawableAmount = safeAdd(withdrawableAmount, withdrawableAmountAS);\n', '        }\n', '        if (walletPESales[msg.sender] > 0) {\n', '            uint256 withdrawableAmountPS = getWithdrawableAmountPES(msg.sender);\n', '            walletPESales[msg.sender] = safeSub(walletPESales[msg.sender], withdrawableAmountPS);\n', '            releasedPESales[msg.sender] = safeAdd(releasedPESales[msg.sender], withdrawableAmountPS);\n', '            withdrawableAmount = safeAdd(withdrawableAmount, withdrawableAmountPS);\n', '        }\n', '        require(withdrawableAmount > 0);\n', '        // Assign tokens to the sender\n', '        balances[msg.sender] = safeAdd(balances[msg.sender], withdrawableAmount);\n', '    }\n', '\n', '    // For wallet Angel Sales\n', '    function getWithdrawableAmountAS(address _investor) public view returns(uint256) {\n', '        require(startWithdraw != 0);\n', '        // interval in months\n', '        uint interval = safeDiv(safeSub(now,startWithdraw),30 days);\n', '        // total allocatedTokens\n', '        uint _allocatedTokens = safeAdd(walletAngelSales[_investor],releasedAngelSales[_investor]);\n', '        // Atleast 6 months\n', '        if (interval < 6) { \n', '            return (0); \n', '        } else if (interval >= 6 && interval < 9) {\n', '            return safeSub(getPercentageAmount(40,_allocatedTokens), releasedAngelSales[_investor]);\n', '        } else if (interval >= 9 && interval < 12) {\n', '            return safeSub(getPercentageAmount(60,_allocatedTokens), releasedAngelSales[_investor]);\n', '        } else if (interval >= 12 && interval < 15) {\n', '            return safeSub(getPercentageAmount(80,_allocatedTokens), releasedAngelSales[_investor]);\n', '        } else if (interval >= 15) {\n', '            return safeSub(_allocatedTokens, releasedAngelSales[_investor]);\n', '        }\n', '    }\n', '\n', '    // For wallet PE Sales\n', '    function getWithdrawableAmountPES(address _investor) public view returns(uint256) {\n', '        require(startWithdraw != 0);\n', '        // interval in months\n', '        uint interval = safeDiv(safeSub(now,startWithdraw),30 days);\n', '        // total allocatedTokens\n', '        uint _allocatedTokens = safeAdd(walletPESales[_investor],releasedPESales[_investor]);\n', '        // Atleast 12 months\n', '        if (interval < 12) { \n', '            return (0); \n', '        } else if (interval >= 12 && interval < 18) {\n', '            return safeSub(getPercentageAmount(40,_allocatedTokens), releasedPESales[_investor]);\n', '        } else if (interval >= 18 && interval < 24) {\n', '            return safeSub(getPercentageAmount(60,_allocatedTokens), releasedPESales[_investor]);\n', '        } else if (interval >= 24 && interval < 30) {\n', '            return safeSub(getPercentageAmount(80,_allocatedTokens), releasedPESales[_investor]);\n', '        } else if (interval >= 30) {\n', '            return safeSub(_allocatedTokens, releasedPESales[_investor]);\n', '        }\n', '    }\n', '\n', '    function getPercentageAmount(uint256 percent,uint256 _tokens) internal pure returns (uint256) {\n', '        return safeDiv(safeMul(_tokens,percent),100);\n', '    }\n', '\n', '    // Sale of the tokens. Investors can call this method to invest into VLT Tokens\n', '    function() payable external {\n', '        // Allow only to invest in ICO stage\n', '        require(startStop);\n', '\n', '        //Sorry !! We only allow to invest with minimum 0.5 Ether as value\n', '        require(msg.value >= (0.5 ether));\n', '\n', '        // multiply by exchange rate to get token amount\n', '        uint256 calculatedTokens = safeMul(msg.value, tokensPerEther);\n', '\n', '        // Wait we check tokens available for assign\n', '        require(balances[ethExchangeWallet] >= calculatedTokens);\n', '\n', '        // Call to Internal function to assign tokens\n', '        assignTokens(msg.sender, calculatedTokens);\n', '    }\n', '\n', "    // Function will transfer the tokens to investor's address\n", '    // Common function code for assigning tokens\n', '    function assignTokens(address investor, uint256 tokens) internal {\n', '        // Debit tokens from ether exchange wallet\n', '        balances[ethExchangeWallet] = safeSub(balances[ethExchangeWallet], tokens);\n', '\n', '        // Assign tokens to the sender\n', '        balances[investor] = safeAdd(balances[investor], tokens);\n', '\n', '        // Finally token assigned to sender, log the creation event\n', '        Transfer(ethExchangeWallet, investor, tokens);\n', '    }\n', '\n', '    function finalizeCrowdSale() external{\n', '        // Check VLT Multisig wallet set or not\n', '        require(VLTMultisig != address(0));\n', '        // Send fund to multisig wallet\n', '        require(VLTMultisig.send(address(this).balance));\n', '    }\n', '\n', '    // @param _who The address of the investor to check balance\n', '    // @return balance tokens of investor address\n', '    function balanceOf(address _who) public constant returns (uint) {\n', '        return balances[_who];\n', '    }\n', '\n', '    // @param _owner The address of the account owning tokens\n', '    // @param _spender The address of the account able to transfer the tokens\n', '    // @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) public constant returns (uint) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', "    //  Transfer `value` VLT tokens from sender's account\n", '    // `msg.sender` to provided account address `to`.\n', '    // @param _to The address of the recipient\n', '    // @param _value The number of VLT tokens to transfer\n', '    // @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint _value) public returns (bool ok) {\n', '        //validate receiver address and value.Not allow 0 value\n', '        require(_to != 0 && _value > 0);\n', '        uint256 senderBalance = balances[msg.sender];\n', '        //Check sender have enough balance\n', '        require(senderBalance >= _value);\n', '        senderBalance = safeSub(senderBalance, _value);\n', '        balances[msg.sender] = senderBalance;\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', "    //  Transfer `value` VLT tokens from sender 'from'\n", '    // to provided account address `to`.\n', '    // @param from The address of the sender\n', '    // @param to The address of the recipient\n', '    // @param value The number of VLT to transfer\n', '    // @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool ok) {\n', '        //validate _from,_to address and _value(Now allow with 0)\n', '        require(_from != 0 && _to != 0 && _value > 0);\n', '        //Check amount is approved by the owner for spender to spent and owner have enough balances\n', '        require(allowed[_from][msg.sender] >= _value && balances[_from] >= _value);\n', '        balances[_from] = safeSub(balances[_from],_value);\n', '        balances[_to] = safeAdd(balances[_to],_value);\n', '        allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    //  `msg.sender` approves `spender` to spend `value` tokens\n', '    // @param spender The address of the account able to transfer the tokens\n', '    // @param value The amount of wei to be approved for transfer\n', '    // @return Whether the approval was successful or not\n', '    function approve(address _spender, uint _value) public returns (bool ok) {\n', '        //validate _spender address\n', '        require(_spender != 0);\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '}']