['pragma solidity ^0.5.16;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract Context {\n', '    constructor () internal { }\n', '    // solhint-disable-previous-line no-empty-blocks\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'contract ERC20 is Context, IERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) private _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '\n', '    uint256 private _totalSupply;\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '    function balanceOf(address account) public view returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '    function transfer(address recipient, uint256 amount) public returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '    function approve(address spender, uint256 amount) public returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\n', '        return true;\n', '    }\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));\n', '        return true;\n', '    }\n', '    function _transfer(address sender, address recipient, uint256 amount) internal {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '    function _mint(address account, uint256 amount) internal {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '    function _burn(address account, uint256 amount) internal {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '    function _approve(address owner, address spender, uint256 amount) internal {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '    function _burnFrom(address account, uint256 amount) internal {\n', '        _burn(account, amount);\n', '        _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));\n', '    }\n', '}\n', '\n', 'contract ERC20Detailed is IERC20 {\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '    constructor (string memory name, string memory symbol, uint8 decimals) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = decimals;\n', '    }\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != 0x0 && codehash != accountHash);\n', '    }\n', '    function toPayable(address account) internal pure returns (address payable) {\n', '        return address(uint160(account));\n', '    }\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-call-value\n', '        (bool success, ) = recipient.call.value(amount)("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', 'interface Controller {\n', '    function withdraw(address, uint) external;\n', '    function balanceOf(address) external view returns (uint);\n', '    function earn(address, uint) external;\n', '}\n', '\n', 'interface AaveCollateralVaultProxy {\n', '    function _borrowerContains(address, address) external view returns (bool);\n', '    function _borrowerVaults(address, uint) external view returns (address);\n', '    function _borrowers(address, uint) external view returns (address);\n', '    function _limits(address, address) external view returns (uint);\n', '    function _ownedVaults(address, uint) external view returns (address);\n', '    function _vaults(address) external view returns (address);\n', '    \n', '    \n', '    function limit(address vault, address spender) external view returns (uint);\n', '    function borrowers(address vault) external view returns (address[] memory);\n', '    function borrowerVaults(address spender) external view returns (address[] memory);\n', '    function increaseLimit(address vault, address spender, uint addedValue) external;\n', '    function decreaseLimit(address vault, address spender, uint subtractedValue) external;\n', '    function setModel(address vault, uint model) external;\n', '    function getBorrow(address vault) external view returns (address);\n', '    function isVaultOwner(address vault, address owner) external view returns (bool);\n', '    function isVault(address vault) external view returns (bool);\n', '    \n', '    function deposit(address vault, address aToken, uint amount) external;\n', '    function withdraw(address vault, address aToken, uint amount) external;\n', '    function borrow(address vault, address reserve, uint amount) external;\n', '    function repay(address vault, address reserve, uint amount) external;\n', '    function getVaults(address owner) external view returns (address[] memory);\n', '    function deployVault(address _asset) external returns (address);\n', '    \n', '    function getVaultAccountData(address _vault)\n', '        external\n', '        view\n', '        returns (\n', '            uint totalLiquidityUSD,\n', '            uint totalCollateralUSD,\n', '            uint totalBorrowsUSD,\n', '            uint totalFeesUSD,\n', '            uint availableBorrowsUSD,\n', '            uint currentLiquidationThreshold,\n', '            uint ltv,\n', '            uint healthFactor\n', '        );\n', '}\n', '\n', 'contract FairLaunchCapitalVault is ERC20, ERC20Detailed {\n', '    using SafeERC20 for IERC20;\n', '    using Address for address;\n', '    using SafeMath for uint256;\n', '    \n', '    IERC20 public token;\n', '    \n', '    uint public min = 10000;\n', '    uint public constant max = 10000;\n', '    \n', '    address public governance;\n', '    address public controller;\n', '    \n', '    AaveCollateralVaultProxy constant public vaults = AaveCollateralVaultProxy(0xf0988322B8392245d6232E520BF3Cdf912b043C4);\n', '    address constant public usdc = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);\n', '    address public vault;\n', '    \n', '    constructor (address _token) public ERC20Detailed(\n', '        string(abi.encodePacked("flc ", ERC20Detailed(_token).name())),\n', '        string(abi.encodePacked("flc", ERC20Detailed(_token).symbol())),\n', '        ERC20Detailed(_token).decimals()\n', '    ) {\n', '        vault = vaults.deployVault(usdc);\n', '        token = IERC20(_token);\n', '        governance = msg.sender;\n', '    }\n', '    \n', '    function balance() public view returns (uint) {\n', '        return token.balanceOf(address(this))\n', '                .add(token.balanceOf(address(vault)));\n', '    }\n', '    \n', '    function setMin(uint _min) external {\n', '        require(msg.sender == governance, "!governance");\n', '        min = _min;\n', '    }\n', '    \n', '    function credit() external {\n', '        token.safeApprove(address(vaults), 0);\n', '        token.safeApprove(address(vaults), token.balanceOf(address(this)));\n', '        vaults.deposit(vault, address(token), token.balanceOf(address(this)));\n', '    }\n', '    \n', '    function increaseLimit(address recipient, uint value) external {\n', '        require(msg.sender == governance, "!governance");\n', '        vaults.increaseLimit(vault, recipient, value);\n', '    }\n', '    function decreaseLimit(address recipient, uint value) external {\n', '        require(msg.sender == governance, "!governance");\n', '        vaults.decreaseLimit(vault, recipient, value);\n', '    }\n', '    function repay(IERC20 reserve, uint amount) external {\n', '        reserve.safeTransferFrom(msg.sender, address(this), amount);\n', '        reserve.safeApprove(address(vaults), 0);\n', '        reserve.safeApprove(address(vaults), reserve.balanceOf(address(this)));\n', '        vaults.repay(vault, address(reserve), amount);\n', '    }\n', '    \n', '    function setGovernance(address _governance) public {\n', '        require(msg.sender == governance, "!governance");\n', '        governance = _governance;\n', '    }\n', '    \n', '    // Custom logic in here for how much the vault allows to be borrowed\n', '    // Sets minimum required on-hand to keep small withdrawals cheap\n', '    function available() public view returns (uint) {\n', '        return token.balanceOf(address(this)).mul(min).div(max);\n', '    }\n', '    \n', '    function depositAll() external {\n', '        deposit(token.balanceOf(msg.sender));\n', '    }\n', '    \n', '    function deposit(uint _amount) public {\n', '        uint _pool = balance();\n', '        uint _before = token.balanceOf(address(this));\n', '        token.safeTransferFrom(msg.sender, address(this), _amount);\n', '        uint _after = token.balanceOf(address(this));\n', '        _amount = _after.sub(_before); // Additional check for deflationary tokens\n', '        uint shares = 0;\n', '        if (totalSupply() == 0) {\n', '            shares = _amount;\n', '        } else {\n', '            shares = (_amount.mul(totalSupply())).div(_pool);\n', '        }\n', '        _mint(msg.sender, shares);\n', '    }\n', '    \n', '    function withdrawAll() external {\n', '        withdraw(balanceOf(msg.sender));\n', '    }\n', '    \n', '    function manage(address reserve, uint amount) external {\n', '        require(msg.sender == governance, "!governance");\n', '        vaults.withdraw(vault, reserve, amount);\n', '    }\n', '    \n', '    function _withdraw(uint _amount) internal {\n', '        vaults.withdraw(vault, address(token), _amount);\n', '    }\n', '    \n', '    // No rebalance implementation for lower fees and faster swaps\n', '    function withdraw(uint _shares) public {\n', '        uint r = (balance().mul(_shares)).div(totalSupply());\n', '        _burn(msg.sender, _shares);\n', '        \n', '        // Check balance\n', '        uint b = token.balanceOf(address(this));\n', '        if (b < r) {\n', '            uint _need = r.sub(b);\n', '            _withdraw(_need);\n', '            uint _after = token.balanceOf(address(this));\n', '            uint _diff = _after.sub(b);\n', '            if (_diff < _need) {\n', '                r = b.add(_diff);\n', '            }\n', '        }\n', '        \n', '        token.safeTransfer(msg.sender, r);\n', '    }\n', '    \n', '    function getPricePerFullShare() public view returns (uint) {\n', '        return balance().mul(1e18).div(totalSupply());\n', '    }\n', '}']