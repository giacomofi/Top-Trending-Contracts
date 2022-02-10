['pragma solidity ^0.5.17;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address account) external view returns (uint);\n', '    function transfer(address recipient, uint amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '    function approve(address spender, uint amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract Context {\n', '    constructor () internal { }\n', '    // solhint-disable-previous-line no-empty-blocks\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '}\n', '\n', 'contract ERC20 is Context, IERC20 {\n', '    using SafeMath for uint;\n', '\n', '    mapping (address => uint) private _balances;\n', '\n', '    mapping (address => mapping (address => uint)) private _allowances;\n', '\n', '    uint private _totalSupply;\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '    function balanceOf(address account) public view returns (uint) {\n', '        return _balances[account];\n', '    }\n', '    function transfer(address recipient, uint amount) public returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '    function allowance(address owner, address spender) public view returns (uint) {\n', '        return _allowances[owner][spender];\n', '    }\n', '    function approve(address spender, uint amount) public returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '    function transferFrom(address sender, address recipient, uint amount) public returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '    function increaseAllowance(address spender, uint addedValue) public returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\n', '        return true;\n', '    }\n', '    function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));\n', '        return true;\n', '    }\n', '    function _transfer(address sender, address recipient, uint amount) internal {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '    function _mint(address account, uint amount) internal {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '    function _burn(address account, uint amount) internal {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '    function _approve(address owner, address spender, uint amount) internal {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '}\n', '\n', 'contract ERC20Detailed is IERC20 {\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '    constructor (string memory name, string memory symbol, uint8 decimals) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = decimals;\n', '    }\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        require(b <= a, errorMessage);\n', '        uint c = a - b;\n', '\n', '        return c;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '    function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint c = a / b;\n', '\n', '        return c;\n', '    }\n', '}\n', '\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != 0x0 && codehash != accountHash);\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint value) internal {\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', 'interface UniswapPair {\n', '    function mint(address to) external returns (uint liquidity);\n', '}\n', '\n', 'interface Oracle {\n', '    function getPriceUSD(address reserve) external view returns (uint);\n', '}\n', '\n', 'interface UniswapRouter {\n', '  function removeLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint liquidity,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountA, uint amountB);\n', '    function factory() external view returns (address);\n', '}\n', '\n', 'interface UniswapFactory {\n', '    function getPair(address tokenA, address tokenB) external view returns (address pair);\n', '    function createPair(address tokenA, address tokenB) external returns (address pair);\n', '}\n', '\n', 'contract StableCreditProtocol is ERC20, ERC20Detailed {\n', '    using SafeERC20 for IERC20;\n', '    using Address for address;\n', '    using SafeMath for uint;\n', '\n', '    // Oracle used for price debt data (external to the AMM balance to avoid internal manipulation)\n', '    Oracle public constant LINK = Oracle(0x271bf4568fb737cc2e6277e9B1EE0034098cDA2a);\n', '    // Uniswap v2\n', '    UniswapRouter public constant UNI = UniswapRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n', '    \n', '    // Maximum credit issued off of deposits (to avoid infinite leverage)\n', '    uint public constant MAX = 7500;\n', '    uint public constant BASE = 10000;\n', '    \n', '    // user => token => credit\n', '    mapping (address => mapping(address => uint)) public credit;\n', '    // user => token => balance\n', '    mapping (address => mapping(address => uint)) public balances;\n', '    \n', '    // How much system liquidity is provided by this asset\n', '    function utilization(address token) public view returns (uint) {\n', '        address pair = UniswapFactory(UNI.factory()).getPair(token, address(this));\n', '        uint _ratio = BASE.sub(BASE.mul(balanceOf(pair)).div(totalSupply()));\n', '        if (_ratio == 0) {\n', '            return MAX;\n', '        }\n', '        return  _ratio > MAX ? MAX : _ratio;\n', '    }\n', '    \n', '    constructor () public ERC20Detailed("StableCredit", "USD", 8) {}\n', '    \n', '    function depositAll(address token) external {\n', '        deposit(token, IERC20(token).balanceOf(msg.sender));\n', '    }\n', '    \n', '    function deposit(address token, uint amount) public {\n', '        _deposit(token, amount);\n', '    }\n', '    \n', '    // UNSAFE: No slippage protection, should not be called directly\n', '    function _deposit(address token, uint amount) internal {\n', '        uint value = LINK.getPriceUSD(token).mul(amount).div(uint256(10)**ERC20Detailed(token).decimals());\n', '        require(value > 0, "!value");\n', '        \n', '        address pair = UniswapFactory(UNI.factory()).getPair(token, address(this));\n', '        if (pair == address(0)) {\n', '            pair = UniswapFactory(UNI.factory()).createPair(token, address(this));\n', '        }\n', '        \n', '        IERC20(token).safeTransferFrom(msg.sender, pair, amount);\n', '        _mint(pair, value); // Amount of aUSD to mint\n', '        \n', '        uint _before = IERC20(pair).balanceOf(address(this));\n', '        UniswapPair(pair).mint(address(this));\n', '        uint _after = IERC20(pair).balanceOf(address(this));\n', '        \n', '\n', '        // Assign LP tokens to user, token <> pair is deterministic thanks to CREATE2\n', '        balances[msg.sender][token] = balances[msg.sender][token].add(_after.sub(_before));\n', '        \n', '        // Calculate utilization ratio of the asset. The more an asset contributes to the system, the less credit issued\n', '        // This mechanism avoids large influx of deposits to overpower the system\n', '        // Calculated after deposit to see impact of current deposit (prevents front-running credit)\n', '        uint _credit = value.mul(utilization(token)).div(BASE);\n', '        credit[msg.sender][token] = credit[msg.sender][token].add(_credit);\n', '        _mint(msg.sender, _credit);\n', '    }\n', '    \n', '    function withdrawAll(address token) external {\n', '        _withdraw(token, IERC20(this).balanceOf(msg.sender));\n', '    }\n', '    \n', '    function withdraw(address token, uint amount) external {\n', '        _withdraw(token, amount);\n', '    }\n', '\n', '    // UNSAFE: No slippage protection, should not be called directly\n', '    function _withdraw(address token, uint amount) internal {\n', '        \n', '        uint _credit = credit[msg.sender][token];\n', '        uint _uni = balances[msg.sender][token];\n', '        \n', '        if (_credit < amount) {\n', '            amount = _credit;\n', '        }\n', '        \n', '        _burn(msg.sender, amount);\n', '        credit[msg.sender][token] = credit[msg.sender][token].sub(amount);\n', '        \n', '        // Calculate % of collateral to release\n', '        _uni = _uni.mul(amount).div(_credit);\n', '        \n', '        address pair = UniswapFactory(UNI.factory()).getPair(token, address(this));\n', '        \n', '        IERC20(pair).safeApprove(address(UNI), 0);\n', '        IERC20(pair).safeApprove(address(UNI), _uni);\n', '        \n', '        UNI.removeLiquidity(\n', '          token,\n', '          address(this),\n', '          _uni,\n', '          0,\n', '          0,\n', '          address(this),\n', '          now.add(1800)\n', '        );\n', '        \n', '        uint amountA = IERC20(token).balanceOf(address(this));\n', '        uint amountB = balanceOf(address(this));\n', '        \n', '        uint valueA = LINK.getPriceUSD(token).mul(amountA).div(uint256(10)**ERC20Detailed(token).decimals());\n', '        require(valueA > 0, "!value");\n', '        \n', '        // Collateral increased in value, but we max at amount B withdrawn\n', '        if (valueA > amountB) {\n', '            valueA = amountB;\n', '        }\n', '        \n', '        _burn(address(this), valueA); // Amount of aUSD to burn (value of A leaving the system)\n', '        \n', '        IERC20(token).safeTransfer(msg.sender, amountA);\n', '        if (amountB > valueA) { // Asset A appreciated in value, receive credit diff\n', '            IERC20(this).safeTransfer(msg.sender, balanceOf(address(this)));\n', '        }\n', '    }\n', '}']