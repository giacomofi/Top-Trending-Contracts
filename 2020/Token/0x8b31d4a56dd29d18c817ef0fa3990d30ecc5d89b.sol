['pragma solidity ^0.5.17;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address account) external view returns (uint);\n', '    function transfer(address recipient, uint amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '    function approve(address spender, uint amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        require(b <= a, errorMessage);\n', '        uint c = a - b;\n', '\n', '        return c;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '    function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint c = a / b;\n', '\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract ERC20 is IERC20 {\n', '    using SafeMath for uint;\n', '\n', '    mapping (address => uint) private _balances;\n', '\n', '    mapping (address => mapping (address => uint)) private _allowances;\n', '\n', '    uint private _totalSupply;\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '    function balanceOf(address account) public view returns (uint) {\n', '        return _balances[account];\n', '    }\n', '    function transfer(address recipient, uint amount) public returns (bool) {\n', '        _transfer(msg.sender, recipient, amount);\n', '        return true;\n', '    }\n', '    function allowance(address owner, address spender) public view returns (uint) {\n', '        return _allowances[owner][spender];\n', '    }\n', '    function approve(address spender, uint amount) public returns (bool) {\n', '        _approve(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '    function transferFrom(address sender, address recipient, uint amount) public returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '    function increaseAllowance(address spender, uint addedValue) public returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));\n', '        return true;\n', '    }\n', '    function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));\n', '        return true;\n', '    }\n', '    function _transfer(address sender, address recipient, uint amount) internal {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '    function _mint(address account, uint amount) internal {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '    function _burn(address account, uint amount) internal {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '    function _approve(address owner, address spender, uint amount) internal {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '}\n', '\n', 'contract ERC20Detailed is IERC20 {\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '    constructor (string memory name, string memory symbol, uint8 decimals) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = decimals;\n', '    }\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '}\n', '\n', 'interface BondingCurve {\n', '    function calculatePurchaseReturn(uint _supply,  uint _reserveBalance, uint32 _reserveRatio, uint _depositAmount) external view returns (uint);\n', '    function calculateSaleReturn(uint _supply, uint _reserveBalance, uint32 _reserveRatio, uint _sellAmount) external view returns (uint);\n', '}\n', '\n', 'contract ContinuousToken is ERC20 {\n', '    using SafeMath for uint;\n', '\n', '    uint public scale = 10**18;\n', '    uint public reserveBalance = 10*scale;\n', '    uint32 public reserveRatio;\n', '    \n', '    BondingCurve constant public CURVE = BondingCurve(0x16F6664c16beDE5d70818654dEfef11769D40983);\n', '\n', '    function _buy(uint _amount) internal returns (uint _bought) {\n', '        _bought = _continuousMint(_amount);\n', '    }\n', '\n', '    function _sell(uint _amount) internal returns (uint _sold) {\n', '        _sold = _continuousBurn(_amount);\n', '    }\n', '\n', '    function calculateContinuousMintReturn(uint _amount) public view returns (uint mintAmount) {\n', '        return CURVE.calculatePurchaseReturn(totalSupply(), reserveBalance, uint32(reserveRatio), _amount);\n', '    }\n', '\n', '    function calculateContinuousBurnReturn(uint _amount) public view returns (uint burnAmount) {\n', '        return CURVE.calculateSaleReturn(totalSupply(), reserveBalance, uint32(reserveRatio), _amount);\n', '    }\n', '\n', '    function _continuousMint(uint _deposit) internal returns (uint) {\n', '        uint amount = calculateContinuousMintReturn(_deposit);\n', '        reserveBalance = reserveBalance.add(_deposit);\n', '        return amount;\n', '    }\n', '\n', '    function _continuousBurn(uint _amount) internal returns (uint) {\n', '        uint reimburseAmount = calculateContinuousBurnReturn(_amount);\n', '        reserveBalance = reserveBalance.sub(reimburseAmount);\n', '        return reimburseAmount;\n', '    }\n', '}\n', '\n', 'contract EminenceCurrency is ContinuousToken, ERC20Detailed {\n', '    mapping(address => bool) public gamemasters;\n', '    mapping(address => bool) public npcs;\n', '    \n', '    event AddGM(address indexed newGM, address indexed gm);\n', '    event RevokeGM(address indexed newGM, address indexed gm);\n', '    event AddNPC(address indexed newNPC, address indexed gm);\n', '    event RevokeNPC(address indexed newNPC, address indexed gm);\n', '    event CashShopBuy(address _from, uint  _amount, uint _deposit);\n', '    event CashShopSell(address _from, uint  _amount, uint _reimbursement);\n', '    \n', '    IERC20 constant public DAI = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);\n', '    \n', '    constructor (string memory name, string memory symbol, uint32 _reserveRatio) public ERC20Detailed(name, symbol, 18) {\n', '        gamemasters[msg.sender] = true;\n', '        reserveRatio = _reserveRatio;\n', '        _mint(msg.sender, 1*scale);\n', '    }\n', '    function addNPC(address _npc) external {\n', '        require(gamemasters[msg.sender], "!gm");\n', '        npcs[_npc] = true;\n', '        emit AddNPC(_npc, msg.sender);\n', '    }\n', '    function revokeNPC(address _npc) external {\n', '        require(gamemasters[msg.sender], "!gm");\n', '        npcs[_npc] = false;\n', '        emit RevokeNPC(_npc, msg.sender);\n', '    }\n', '    function addGM(address _gm) external {\n', '        require(gamemasters[msg.sender], "!gm");\n', '        gamemasters[_gm] = true;\n', '        emit AddGM(_gm, msg.sender);\n', '    }\n', '    function revokeGM(address _gm) external {\n', '        require(gamemasters[msg.sender], "!gm");\n', '        gamemasters[_gm] = false;\n', '        emit RevokeGM(_gm, msg.sender);\n', '    }\n', '    function award(address _to, uint _amount) external {\n', '        require(gamemasters[msg.sender], "!gm");\n', '        _mint(_to, _amount);\n', '    }\n', '    function claim(address _from, uint _amount) external {\n', '        require(gamemasters[msg.sender]||npcs[msg.sender], "!gm");\n', '        _burn(_from, _amount);\n', '    }\n', '    function buy(uint _amount, uint _min) external returns (uint _bought) {\n', '        _bought = _buy(_amount);\n', '        require(_bought >= _min, "slippage");\n', '        DAI.transferFrom(msg.sender, address(this), _amount);\n', '        _mint(msg.sender, _bought);\n', '        emit CashShopBuy(msg.sender, _bought, _amount);\n', '    }\n', '    function sell(uint _amount, uint _min) external returns (uint _bought) {\n', '        _bought = _sell(_amount);\n', '        require(_bought >= _min, "slippage");\n', '        _burn(msg.sender, _amount);\n', '        DAI.transfer(msg.sender, _bought);\n', '        emit CashShopSell(msg.sender, _amount, _bought);\n', '    }\n', '}']