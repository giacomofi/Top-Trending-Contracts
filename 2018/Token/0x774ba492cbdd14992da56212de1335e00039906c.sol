['pragma solidity ^0.4.24;\n', '//Spielleys Divide Drain and Destroy minigame v 1.0\n', '\n', '//99% of eth payed is returned directly to players according to their stack of shares vs totalSupply\n', '// players need to fetch divs themselves or perform transactions to get the divs\n', '// 1% will be set aside to buy P3D with Masternode reward for UI builders\n', '// 100% of vanity change sales will go to buying P3D with (UIdev MN reward)\n', '\n', '// Game Concept: (inspired by a hill type idea for kotch https://kotch.dvx.me/#/)\n', '// - Divide: Convert eth spent to buy shares factor eth value *3 \n', '// - Drain : Drain someones shares, enemy loses shares eth value *2, you gain these\n', '// - Destroy : Burn an enemies stack of shares at rate of eth value *5\n', '\n', '// Steps of the transactions\n', '// 1: update total divs with payed amount\n', '// 2: fetchdivs from accounts in the transactions\n', '// 3: update shares\n', '\n', '// no matter your innitial shares amount, \n', "// you'll still get eth for getting destroyed according to your shares owned\n", '\n', '\n', '// Thank you for playing Spielleys contract creations.\n', '// speilley is not liable for any contract bugs known and unknown.\n', '//\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = 0x0B0eFad4aE088a88fFDC50BCe5Fb63c6936b9220;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', 'interface HourglassInterface  {\n', '    function() payable external;\n', '    function buy(address _playerAddress) payable external returns(uint256);\n', '    function sell(uint256 _amountOfTokens) external;\n', '    function reinvest() external;\n', '    function withdraw() external;\n', '    function exit() external;\n', '    function dividendsOf(address _playerAddress) external view returns(uint256);\n', '    function balanceOf(address _playerAddress) external view returns(uint256);\n', '    function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);\n', '    function stakingRequirement() external view returns(uint256);\n', '}\n', 'interface SPASMInterface  {\n', '    function() payable external;\n', '    function disburse() external  payable;\n', '}\n', '// ----------------------------------------------------------------------------\n', '// Contract function to receive approval and execute function in one call\n', '//\n', '// Borrowed from MiniMeToken\n', '// ----------------------------------------------------------------------------\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals and a\n', '// fixed supply\n', '// ----------------------------------------------------------------------------\n', 'contract DivideDrainDestroy is ERC20Interface, Owned {\n', '    using SafeMath for uint;\n', '\n', '    string public symbol;\n', '    string public  name;\n', '    uint8 public decimals;\n', '    uint _totalSupply;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    constructor() public {\n', '        symbol = "DDD";\n', '        name = "Divide Drain and Destroy";\n', '        decimals = 0;\n', '        _totalSupply = 1;\n', '        balances[owner] = _totalSupply;\n', '        emit Transfer(address(0),owner, _totalSupply);\n', '        \n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply.sub(balances[address(0)]);\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to `to` account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) updateAccount(to) updateAccount(msg.sender) public returns (bool success) {\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account\n", '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces \n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens)updateAccount(to) updateAccount(from) public returns (bool success) {\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account. The `spender` contract function\n", '    // `receiveApproval(...)` is then executed\n', '    // ------------------------------------------------------------------------\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '\n', '\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', '    // ------------------------------------------------------------------------\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '\n', '// divfunctions\n', 'HourglassInterface constant P3Dcontract_ = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);\n', 'SPASMInterface constant SPASM_ = SPASMInterface(0xfaAe60F2CE6491886C9f7C9356bd92F688cA66a1);\n', '// view functions\n', 'function harvestabledivs()\n', '        view\n', '        public\n', '        returns(uint256)\n', '    {\n', '        return ( P3Dcontract_.dividendsOf(address(this)))  ;\n', '    }\n', 'function amountofp3d() external view returns(uint256){\n', '    return ( P3Dcontract_.balanceOf(address(this)))  ;\n', '}\n', '//divsection\n', 'uint256 public pointMultiplier = 10e18;\n', 'struct Account {\n', '  uint balance;\n', '  uint lastDividendPoints;\n', '}\n', 'mapping(address=>Account) accounts;\n', 'mapping(address => uint256) public ETHtoP3Dbymasternode;\n', 'mapping(address => string) public Vanity;\n', 'uint public ethtotalSupply;\n', 'uint public totalDividendPoints;\n', 'uint public unclaimedDividends;\n', '\n', 'function dividendsOwing(address account) public view returns(uint256) {\n', '  uint256 newDividendPoints = totalDividendPoints.sub(accounts[account].lastDividendPoints);\n', '  return (balances[account] * newDividendPoints) / pointMultiplier;\n', '}\n', 'modifier updateAccount(address account) {\n', '  uint256 owing = dividendsOwing(account);\n', '  if(owing > 0) {\n', '    unclaimedDividends = unclaimedDividends.sub(owing);\n', '    \n', '    account.transfer(owing);\n', '  }\n', '  accounts[account].lastDividendPoints = totalDividendPoints;\n', '  _;\n', '}\n', 'function () external payable{}\n', 'function fetchdivs(address toupdate) public updateAccount(toupdate){}\n', 'function disburse(address masternode) public  payable {\n', '    uint256 amount = msg.value;\n', '    uint256 base = amount.div(100);\n', '    uint256 amt2 = amount.sub(base);\n', '  totalDividendPoints = totalDividendPoints.add(amt2.mul(pointMultiplier).div(_totalSupply));\n', ' unclaimedDividends = unclaimedDividends.add(amt2);\n', ' ETHtoP3Dbymasternode[masternode] = ETHtoP3Dbymasternode[masternode].add(base);\n', '}\n', 'function Divide(address masternode) public  payable{\n', '    uint256 amount = msg.value.mul(3);\n', '    address sender = msg.sender;\n', '    uint256 sup = _totalSupply;//totalSupply\n', '    require(amount >= 1);\n', '    sup = sup.add(amount);\n', '    disburse(masternode);\n', '    fetchdivs(msg.sender);\n', '    balances[msg.sender] = balances[sender].add(amount);\n', '    emit Transfer(0,sender, amount);\n', '     _totalSupply =  sup;\n', '\n', '}\n', 'function Drain(address drainfrom, address masternode) public  payable{\n', '    uint256 amount = msg.value.mul(2);\n', '    address sender = msg.sender;\n', '    uint256 sup = _totalSupply;//totalSupply\n', '    require(amount >= 1);\n', '    require(amount <= balances[drainfrom]);\n', '    \n', '    disburse(masternode);\n', '    fetchdivs(msg.sender);\n', '    fetchdivs(drainfrom);\n', '    balances[msg.sender] = balances[sender].add(amount);\n', '    balances[drainfrom] = balances[drainfrom].sub(amount);\n', '    emit Transfer(drainfrom,sender, amount);\n', '     _totalSupply =  sup.add(amount);\n', '    \n', '}\n', 'function Destroy(address destroyfrom, address masternode) public  payable{\n', '    uint256 amount = msg.value.mul(5);\n', '    uint256 sup = _totalSupply;//totalSupply\n', '    require(amount >= 1);\n', '    require(amount <= balances[destroyfrom]);\n', '        disburse(masternode);\n', '        fetchdivs(msg.sender);\n', '    fetchdivs(destroyfrom);\n', '    balances[destroyfrom] = balances[destroyfrom].sub(amount);\n', '    emit Transfer(destroyfrom,0x0, amount);\n', '     _totalSupply =  sup.sub(amount);\n', '\n', '}\n', 'function Expand(address masternode) public {\n', '    \n', '    uint256 amt = ETHtoP3Dbymasternode[masternode];\n', '    ETHtoP3Dbymasternode[masternode] = 0;\n', "    if(masternode == 0x0){masternode = 0x989eB9629225B8C06997eF0577CC08535fD789F9;}// raffle3d's address\n", '    P3Dcontract_.buy.value(amt)(masternode);\n', '    \n', '}\n', 'function changevanity(string van , address masternode) public payable{\n', '    require(msg.value >= 100  finney);\n', '    Vanity[msg.sender] = van;\n', '    ETHtoP3Dbymasternode[masternode] = ETHtoP3Dbymasternode[masternode].add(msg.value);\n', '}\n', 'function P3DDivstocontract() public payable{\n', '    uint256 divs = harvestabledivs();\n', '    require(divs > 0);\n', ' \n', 'P3Dcontract_.withdraw();\n', '    //1% to owner\n', '    uint256 base = divs.div(100);\n', '    uint256 amt2 = divs.sub(base);\n', '    SPASM_.disburse.value(base)();// to dev fee sharing contract\n', '   totalDividendPoints = totalDividendPoints.add(amt2.mul(pointMultiplier).div(_totalSupply));\n', ' unclaimedDividends = unclaimedDividends.add(amt2);\n', '}\n', '}']