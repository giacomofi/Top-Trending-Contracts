['pragma solidity 0.5.17;\n', '\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address account) external view returns (uint);\n', '    function transfer(address recipient, uint amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '    function approve(address spender, uint amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract Context {\n', '    constructor () internal { }\n', '    // solhint-disable-previous-line no-empty-blocks\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '}\n', '\n', 'contract ERC20 is Context, IERC20 {\n', '    using SafeMath for uint;\n', '\n', '    mapping (address => uint) private _balances;\n', '\n', '    mapping (address => mapping (address => uint)) private _allowances;\n', '\n', '    uint private _totalSupply;\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '    function balanceOf(address account) public view returns (uint) {\n', '        return _balances[account];\n', '    }\n', '    function transfer(address recipient, uint amount) public returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '    function allowance(address owner, address spender) public view returns (uint) {\n', '        return _allowances[owner][spender];\n', '    }\n', '    function approve(address spender, uint amount) public returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '    function transferFrom(address sender, address recipient, uint amount) public returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '    function increaseAllowance(address spender, uint addedValue) public returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\n', '        return true;\n', '    }\n', '    function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));\n', '        return true;\n', '    }\n', '    function _transfer(address sender, address recipient, uint amount) internal {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '    function _mint(address account, uint amount) internal {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '    function _burn(address account, uint amount) internal {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '    function _approve(address owner, address spender, uint amount) internal {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '}\n', '\n', 'contract ERC20Detailed is IERC20 {\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '    constructor (string memory name, string memory symbol, uint8 decimals) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = decimals;\n', '    }\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        require(b <= a, errorMessage);\n', '        uint c = a - b;\n', '\n', '        return c;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '    function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint c = a / b;\n', '\n', '        return c;\n', '    }\n', '    function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', '        if(a % b != 0)\n', '            c = c + 1;\n', '        return c;\n', '    }\n', '}\n', '\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != 0x0 && codehash != accountHash);\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint value) internal {\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', 'library SignedSafeMath {\n', '    int256 constant private _INT256_MIN = -2**255;\n', '    function mul(int256 a, int256 b) internal pure returns (int256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");\n', '\n', '        int256 c = a * b;\n', '        require(c / a == b, "SignedSafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '    function div(int256 a, int256 b) internal pure returns (int256) {\n', '        require(b != 0, "SignedSafeMath: division by zero");\n', '        require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");\n', '\n', '        int256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '    function sub(int256 a, int256 b) internal pure returns (int256) {\n', '        int256 c = a - b;\n', '        require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");\n', '\n', '        return c;\n', '    }\n', '    function add(int256 a, int256 b) internal pure returns (int256) {\n', '        int256 c = a + b;\n', '        require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '    function sqrt(int256 x) internal pure returns (int256) {\n', '        int256 z = add(x / 2, 1);\n', '        int256 y = x;\n', '        while (z < y)\n', '        {\n', '            y = z;\n', '            z = ((add((x / z), z)) / 2);\n', '        }\n', '        return y;\n', '    }\n', '}\n', '\n', 'contract DynamicSwap is ERC20, ERC20Detailed {\n', '    using SafeMath for uint;\n', '    using SignedSafeMath for int256;\n', '    using SafeERC20 for IERC20;\n', '    \n', '    mapping(address => bool) coins;\n', '    address public governance;\n', '    \n', '    constructor() public ERC20Detailed("DynamicSwap", "dUSD", 18) {\n', '        governance = msg.sender;\n', '    }\n', '    \n', '    function setGovernance(address _governance) external {\n', '        require(msg.sender == governance, "!governance");\n', '        governance = _governance;\n', '    }\n', '    \n', '    function approveCoins(address _coin) external {\n', '        require(msg.sender == governance, "!governance");\n', '        coins[_coin] = true;\n', '    }\n', '    \n', '    uint public fee = 99985;\n', '    uint public constant BASE = 100000;\n', '    \n', '    uint public constant A = 0.75e18;\n', '    uint public count = 0;\n', '    mapping(address => bool) tokens;\n', '    \n', '    function f(int256 _x, int256 x, int256 y) internal pure returns (int256 _y) {\n', '        int256 k;\n', '        int256 c;\n', '        {\n', '            int256 u = x.add(y.mul(int256(A)).div(1e18));\n', '            int256 v = y.add(x.mul(int256(A)).div(1e18));\n', '            k = u.mul(v);\n', '            c = _x.mul(_x).sub(k.mul(1e18).div(int256(A)));\n', '        }\n', '        \n', '        int256 cst = int256(A).add(int256(1e36).div(int256(A)));\n', '        int256 _b = _x.mul(cst).div(1e18);\n', '\n', '        int256 D = _b.mul(_b).sub(c.mul(4));\n', '\n', '        require(D >= 0, "!root");\n', '\n', '        _y = (-_b).add(D.sqrt()).div(2);\n', '    }\n', '\n', '    // Calculate output given exact input\n', '    function getOutExactIn(int256 input, int256 x, int256 y) public pure returns (uint) {\n', '        int256 _x = x.add(input);\n', '        int256 _y = f(_x, x, y);\n', '        return uint(y.sub(_y));\n', '    }\n', '\n', '    // Calculate input given exact output\n', '    function getInExactOut(int256 output, int256 x, int256 y) public pure returns (uint) {\n', '        int256 _y = y.sub(output);\n', '        int256 _x = f(_y, y, x);\n', '        return uint(_x.sub(x));\n', '    }\n', '    \n', '    // Normalize coin to 1e18\n', '    function normalize1e18(IERC20 token, uint _amount) public view returns (uint) {\n', '        uint _decimals = ERC20Detailed(address(token)).decimals();\n', '        if (_decimals == uint(18)) {\n', '            return _amount;\n', '        } else {\n', '            return _amount.mul(1e18).div(uint(10)**_decimals);\n', '        }\n', '    }\n', '    \n', '    // Normalize coin to original decimals \n', '    function normalize(IERC20 token, uint _amount) public view returns (uint) {\n', '        uint _decimals = ERC20Detailed(address(token)).decimals();\n', '        if (_decimals == uint(18)) {\n', '            return _amount;\n', '        } else {\n', '            return _amount.mul(uint(10)**_decimals).div(1e18);\n', '        }\n', '    }\n', '    \n', '    // Contract balance of coin normalized to 1e18\n', '    function balance(IERC20 token) public view returns (uint) {\n', '        return normalize1e18(token, token.balanceOf(address(this)));\n', '    }\n', '    \n', '    // Converter helper to int256\n', '    function i(uint x) public pure returns (int256) {\n', '        return int256(x);\n', '    }\n', '\n', '    function swapExactAmountIn(IERC20 from, IERC20 to, uint input, uint minOutput, uint deadline) external returns (uint output) {\n', '        require(block.timestamp <= deadline, "expired");\n', '        \n', '        output = normalize(to, getOutExactIn(i(normalize1e18(from, input.mul(fee).div(BASE))), i(balance(from)), i(balance(to))));\n', '        \n', '        require(output >= minOutput, "slippage");\n', '        \n', '        from.safeTransferFrom(msg.sender, address(this), input);\n', '        to.safeTransfer(msg.sender, output);\n', '    }\n', '\n', '    function swapExactAmountOut(IERC20 from, IERC20 to, uint maxInput, uint output, uint deadline) external returns (uint input) {\n', '        require(block.timestamp <= deadline, "expired");\n', '        \n', '        input = normalize(from, getInExactOut(i(normalize1e18(to, output)), i(balance(from)), i(balance(to))));\n', '        input = input.mul(BASE).divCeil(fee);\n', '        \n', '        require(input <= maxInput, "slippage");\n', '        \n', '        from.safeTransferFrom(msg.sender, address(this), input);\n', '        to.safeTransfer(msg.sender, output);\n', '    }\n', '    \n', '    function addLiquidityExactIn(IERC20 from, uint input, uint minOutput, uint deadline) external returns (uint output) {\n', '        require(coins[address(from)]==true, "!coin");\n', '        require(block.timestamp <= deadline, "expired");\n', '        \n', '        if (totalSupply() == 0) {\n', '            output = normalize1e18(from, input);\n', '        } else {\n', '            output = getOutExactIn(i(normalize1e18(from, input.mul(fee).div(BASE))), i(balance(from)), i(totalSupply().div(count)));\n', '        }\n', '        \n', '        require(output >= minOutput, "slippage");\n', '        \n', '        from.safeTransferFrom(msg.sender, address(this), input);\n', '        _mint(msg.sender, output);\n', '        \n', '        if (!tokens[address(from)] && balance(from) > 0 ) {\n', '            tokens[address(from)] = true;\n', '            count = count.add(1);\n', '        }\n', '    }\n', '    \n', '    function addLiquidityExactOut(IERC20 from, uint maxInput, uint output, uint deadline) external returns (uint input) {\n', '        require(coins[address(from)] == true, "!coin");\n', '        require(block.timestamp <= deadline, "expired");\n', '        \n', '        if (totalSupply() == 0) {\n', '            input = normalize(from, output);\n', '        } else {\n', '            input = normalize(from, getInExactOut(i(output), i(balance(from)), i(totalSupply().div(count))));\n', '            input = input.mul(BASE).divCeil(fee);\n', '        }\n', '        \n', '        require(input <= maxInput, "slippage");\n', '\n', '        from.safeTransferFrom(msg.sender, address(this), input);\n', '        _mint(msg.sender, output);\n', '        \n', '        if (!tokens[address(from)] && balance(from) > 0 ) {\n', '            tokens[address(from)] = true;\n', '            count = count.add(1);\n', '        }\n', '    }\n', '    \n', '    function removeLiquidityExactIn(IERC20 to, uint input, uint minOutput, uint deadline) external returns (uint output) {\n', '        require(block.timestamp <= deadline, "expired");\n', '        \n', '        output = normalize(to, getOutExactIn(i(input.mul(fee).div(BASE)), i(totalSupply().div(count)), i(balance(to))));\n', '        \n', '        require(output >= minOutput, "slippage");\n', '        \n', '        _burn(msg.sender, input);\n', '        to.safeTransfer(msg.sender, output);\n', '        \n', '        if (balance(to)==0) {\n', '            tokens[address(to)] = false;\n', '        }\n', '    }\n', '    \n', '    function removeLiquidityExactOut(IERC20 to, uint maxInput, uint output, uint deadline) external returns (uint input) {\n', '        require(block.timestamp <= deadline, "expired");\n', '        \n', '        input = getInExactOut(i(normalize1e18(to, input)), i(totalSupply().div(count)), i(balance(to)));\n', '        input = input.mul(BASE).divCeil(fee);\n', '        \n', '        require(input <= maxInput, "slippage");\n', '\n', '        _burn(msg.sender, input);\n', '        to.safeTransfer(msg.sender, output);\n', '        \n', '        if (balance(to)==0) {\n', '            tokens[address(to)] = false;\n', '        }\n', '    }\n', '}']