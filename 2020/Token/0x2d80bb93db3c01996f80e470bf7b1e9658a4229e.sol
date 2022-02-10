['/*\n', 'FINPLETHER GIVEAWAY\n', ' $500 000\xa0000 USD \n', '\n', 'TO JOIN\n', 'THE GIVEAWAY \n', '\n', 'To Participate You just need to send between\n', '0.05 ETH to 1000 ETH \n', 'YOU INSTANTLY GET USD BACK TO YOUR WALLET between\n', '0.5 ETH TO 5000 ETH \n', 'For example, if you send:\n', '0.05 ETH YOU WILL GET BACK 0.5 ETH\n', '0.50 ETH YOU WILL GET BACK 5 ETH\n', '1 ETH YOU WILL GET BACK 5 ETH\n', '10 ETH YOU WILL GET BACK 50 ETH\n', '100 ETH YOU WILL GET BACK 500 ETH\n', '1000 ETH YOU WILL GET BACK 5000 ETH\n', '\n', '*/\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        require(token.transfer(to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        require(token.transferFrom(from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        require((value == 0) || (token.allowance(msg.sender, spender) == 0));\n', '        require(token.approve(spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        require(token.approve(spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value);\n', '        require(token.approve(spender, newAllowance));\n', '    }\n', '}\n', '\n', 'contract ReentrancyGuard {\n', '    uint256 private _guardCounter;\n', '\n', '    constructor () internal {\n', '        _guardCounter = 1;\n', '    }\n', '\n', '    modifier nonReentrant() {\n', '        _guardCounter += 1;\n', '        uint256 localCounter = _guardCounter;\n', '        _;\n', '        require(localCounter == _guardCounter);\n', '    }\n', '}\n', '\n', 'contract Crowdsale is ReentrancyGuard {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '\n', '    IERC20 private _token;\n', '   \n', '    address payable private _wallet;\n', '    uint256 private _rate;\n', '    uint256 private _weiRaised;\n', '\n', '    event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '    constructor (uint256 rate, address payable wallet, IERC20 token) public {\n', '        require(rate > 0);\n', '        require(wallet != address(0));\n', '        require(address(token) != address(0));\n', '\n', '        _rate = rate;\n', '        _wallet = wallet;\n', '        _token = token;\n', '    }\n', '\n', '    function () external payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    function token() public view returns (IERC20) {\n', '        return _token;\n', '    }\n', '\n', '    function wallet() public view returns (address payable) {\n', '        return _wallet;\n', '    }\n', '\n', '    function rate() public view returns (uint256) {\n', '        return _rate;\n', '    }\n', '\n', '    function weiRaised() public view returns (uint256) {\n', '        return _weiRaised;\n', '    }\n', '\n', '    function buyTokens(address beneficiary) public nonReentrant payable {\n', '        uint256 weiAmount = msg.value;\n', '        _preValidatePurchase(beneficiary, weiAmount);\n', '        uint256 tokens = _getTokenAmount(weiAmount);\n', '\n', '        _weiRaised = _weiRaised.add(weiAmount);\n', '\n', '        _processPurchase(beneficiary, tokens);\n', '        emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);\n', '\n', '        _updatePurchasingState(beneficiary, weiAmount);\n', '\n', '        _forwardFunds();\n', '        _postValidatePurchase(beneficiary, weiAmount);\n', '    }\n', '\n', '    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {\n', '        require(beneficiary != address(0));\n', '        require(weiAmount != 0);\n', '    }\n', '\n', '    function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {\n', '    }\n', '\n', '    function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {\n', '        _token.safeTransfer(beneficiary, tokenAmount);\n', '    }\n', '\n', '    function _processPurchase(address beneficiary, uint256 tokenAmount) internal {\n', '        _deliverTokens(beneficiary, tokenAmount);\n', '    }\n', '\n', '    function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {\n', '        // solhint-disable-previous-line no-empty-blocks\n', '    }\n', '\n', '    function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {\n', '        uint256 tokenAmount = weiAmount.mul(_rate);\n', '        if (weiAmount >= 1 ether && weiAmount < 5 ether)  tokenAmount = tokenAmount.mul(125).div(100); \n', '        else if (weiAmount >= 5 ether && weiAmount < 10 ether) tokenAmount = tokenAmount.mul(135).div(100); \n', '        else if (weiAmount >= 10 ether && weiAmount < 30 ether) tokenAmount = tokenAmount.mul(140).div(100); \n', '        else if (weiAmount >= 30 ether && weiAmount < 150 ether) tokenAmount = tokenAmount.mul(150).div(100); \n', '        else if (weiAmount >= 150 ether && weiAmount < 1000 ether) tokenAmount = tokenAmount.mul(60).div(100);\n', '\n', '\n', '        if (block.timestamp >= 1602450846 && block.timestamp < 1603182600)  tokenAmount = tokenAmount.mul(185).div(100);\n', '        else if (block.timestamp >= 1603182600 && block.timestamp < 1604565000) tokenAmount = tokenAmount.mul(175).div(100);\n', '        else if (block.timestamp >= 1604565000 && block.timestamp < 1605861000) tokenAmount = tokenAmount.mul(165).div(100);\n', '        else if (block.timestamp >= 1605861000 && block.timestamp < 1606725000) tokenAmount = tokenAmount.mul(150).div(100);\n', '        else if (block.timestamp >= 1606725000 && block.timestamp < 1607157000) tokenAmount = tokenAmount.mul(140).div(100);  \n', '        else if (block.timestamp >= 1607157000 && block.timestamp < 1607589000) tokenAmount = tokenAmount.mul(130).div(100);\n', '        else if (block.timestamp >= 1607589000 && block.timestamp < 1608021000) tokenAmount = tokenAmount.mul(120).div(100);\n', '        else if (block.timestamp >= 1608021000 && block.timestamp < 1608366600) tokenAmount = tokenAmount.mul(110).div(100);\n', '        \n', '        return tokenAmount;\n', '    }\n', '\n', '    function _forwardFunds() internal {\n', '        _wallet.transfer(msg.value);\n', '    }\n', '}\n', '\n', 'contract ERC20 is IERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) private _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowed;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        return _balances[owner];\n', '    }\n', '\n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return _allowed[owner][spender];\n', '    }\n', '\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '        _transfer(from, to, value);\n', '        emit Approval(from, msg.sender, _allowed[from][msg.sender]);\n', '        return true;\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    function _transfer(address from, address to, uint256 value) internal {\n', '        require(to != address(0));\n', '\n', '        _balances[from] = _balances[from].sub(value);\n', '        _balances[to] = _balances[to].add(value);\n', '        emit Transfer(from, to, value);\n', '    }\n', '\n', '    function _mint(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '\n', '        _totalSupply = _totalSupply.add(value);\n', '        _balances[account] = _balances[account].add(value);\n', '        emit Transfer(address(0), account, value);\n', '    }\n', '\n', '    function _burn(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '\n', '        _totalSupply = _totalSupply.sub(value);\n', '        _balances[account] = _balances[account].sub(value);\n', '        emit Transfer(account, address(0), value);\n', '    }\n', '\n', '    function _burnFrom(address account, uint256 value) internal {\n', '        _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);\n', '        _burn(account, value);\n', '        emit Approval(account, msg.sender, _allowed[account][msg.sender]);\n', '    }\n', '}\n', '\n', 'library Roles {\n', '    struct Role {\n', '        mapping (address => bool) bearer;\n', '    }\n', '\n', '    function add(Role storage role, address account) internal {\n', '        require(account != address(0));\n', '        require(!has(role, account));\n', '\n', '        role.bearer[account] = true;\n', '    }\n', '\n', '    function remove(Role storage role, address account) internal {\n', '        require(account != address(0));\n', '        require(has(role, account));\n', '\n', '        role.bearer[account] = false;\n', '    }\n', '\n', '    function has(Role storage role, address account) internal view returns (bool) {\n', '        require(account != address(0));\n', '        return role.bearer[account];\n', '    }\n', '}\n', '\n', 'contract MinterRole {\n', '    using Roles for Roles.Role;\n', '\n', '    event MinterAdded(address indexed account);\n', '    event MinterRemoved(address indexed account);\n', '\n', '    Roles.Role private _minters;\n', '\n', '    constructor () internal {\n', '        _addMinter(msg.sender);\n', '    }\n', '\n', '    modifier onlyMinter() {\n', '        require(isMinter(msg.sender));\n', '        _;\n', '    }\n', '\n', '    function isMinter(address account) public view returns (bool) {\n', '        return _minters.has(account);\n', '    }\n', '\n', '    function addMinter(address account) public onlyMinter {\n', '        _addMinter(account);\n', '    }\n', '\n', '    function renounceMinter() public {\n', '        _removeMinter(msg.sender);\n', '    }\n', '\n', '    function _addMinter(address account) internal {\n', '        _minters.add(account);\n', '        emit MinterAdded(account);\n', '    }\n', '\n', '    function _removeMinter(address account) internal {\n', '        _minters.remove(account);\n', '        emit MinterRemoved(account);\n', '    }\n', '}\n', '\n', 'contract ERC20Mintable is ERC20, MinterRole {\n', '    function mint(address to, uint256 value) public onlyMinter returns (bool) {\n', '        _mint(to, value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract MintedCrowdsale is Crowdsale {\n', '    function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {\n', '        require(ERC20Mintable(address(token())).mint(beneficiary, tokenAmount));\n', '    }\n', '}\n', '\n', 'contract CappedCrowdsale is Crowdsale {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 private _cap;\n', '\n', '    constructor (uint256 cap) public {\n', '        require(cap > 0);\n', '        _cap = cap;\n', '    }\n', '\n', '    function cap() public view returns (uint256) {\n', '        return _cap;\n', '    }\n', '\n', '    function capReached() public view returns (bool) {\n', '        return weiRaised() >= _cap;\n', '    }\n', '\n', '    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {\n', '        super._preValidatePurchase(beneficiary, weiAmount);\n', '        require(weiRaised().add(weiAmount) <= _cap);\n', '    }\n', '}\n', '\n', 'contract TimedCrowdsale is Crowdsale {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 private _openingTime;\n', '    uint256 private _closingTime;\n', '\n', '    modifier onlyWhileOpen {\n', '        require(isOpen());\n', '        _;\n', '    }\n', '\n', '    constructor (uint256 openingTime, uint256 closingTime) public {\n', '        require(closingTime > openingTime);\n', '\n', '        _openingTime = openingTime;\n', '        _closingTime = closingTime;\n', '    }\n', '\n', '    function openingTime() public view returns (uint256) {\n', '        return _openingTime;\n', '    }\n', '\n', '    function closingTime() public view returns (uint256) {\n', '        return _closingTime;\n', '    }\n', '\n', '    function isOpen() public view returns (bool) {\n', '        return block.timestamp >= _openingTime && block.timestamp <= _closingTime;\n', '    }\n', '\n', '    function hasClosed() public view returns (bool) {\n', '        return block.timestamp > _closingTime;\n', '    }\n', '\n', '    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {\n', '        super._preValidatePurchase(beneficiary, weiAmount);\n', '    }\n', '}\n', '\n', '\n', 'contract GIVEAWAY is CappedCrowdsale, TimedCrowdsale, MintedCrowdsale {\n', ' constructor(\n', '  uint256 _openingTime,\n', '  uint256 _closingTime,\n', '  uint256 _rate,\n', '  address payable _wallet,\n', '  uint256 _cap,\n', '  ERC20Mintable _token\n', ' )\n', '  public\n', '  Crowdsale(_rate, _wallet, _token)\n', '  CappedCrowdsale(_cap)\n', '  TimedCrowdsale(_openingTime, _closingTime)\n', ' {\n', '\n', ' }\n', '}']