['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-31\n', '*/\n', '\n', '//SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.6;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address account) external view returns (uint);\n', '    function transfer(address recipient, uint amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '    function approve(address spender, uint amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        require(b <= a, errorMessage);\n', '        uint c = a - b;\n', '\n', '        return c;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '    function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint c = a / b;\n', '\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Context {\n', '    constructor () public { }\n', '    // solhint-disable-previous-line no-empty-blocks\n', '\n', '    function _msgSender() internal view returns (address) {\n', '        return msg.sender;\n', '    }\n', '}\n', '\n', 'contract ERC20 is Context, IERC20 {\n', '    using SafeMath for uint;\n', '\n', '    mapping (address => uint) internal _balances;\n', '\n', '    mapping (address => mapping (address => uint)) internal _allowances;\n', '    \n', '    mapping (uint => mapping(address => uint)) public tokenHolders;\n', '    \n', '     mapping(uint => address) public addressHolders;\n', '\n', '    uint internal _totalSupply;\n', '    \n', '    uint public _circulatingSupply;\n', '    \n', '    uint256 count = 1;\n', '    \n', '      uint256 public holdingReward;\n', '   \n', '    address walletAddress = 0xf51690575E82fD91A976A12A9C265651A7B77B3e;\n', '    address fundsWallet = 0xfa97Ec471ee2bc062Ba4E13665acc296dFd721BF;\n', '    \n', '    function totalSupply() public view override returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '    function balanceOf(address account) public view override returns (uint) {\n', '        return _balances[account];\n', '    }\n', '    function transfer(address recipient, uint amount) public override  returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '    function allowance(address owner, address spender) public view override returns (uint) {\n', '        return _allowances[owner][spender];\n', '    }\n', '    function approve(address spender, uint amount) public override returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '    function transferFrom(address sender, address recipient, uint amount) public override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '    function increaseAllowance(address spender, uint addedValue) public returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\n', '        return true;\n', '    }\n', '    function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));\n', '        return true;\n', '    }\n', '    function _transfer(address sender, address recipient, uint amount) internal {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        uint256 _OnePercent = calculateOnePercent(amount);\n', '        _burn(msg.sender, _OnePercent);\n', '        \n', '        uint256 _TwoPercent = calculateTwoPercent(amount);\n', '        sendToWallet(msg.sender, walletAddress, _TwoPercent);\n', '        \n', '        \n', '        uint256 _PointTwoPercent = calculatePointTwoPercent(amount);\n', '        sendToFundsWallet(msg.sender,fundsWallet,_PointTwoPercent);\n', '        divideAmongHolders(_OnePercent, count);\n', '        \n', '        uint256 AmountGranted = amount - ((_OnePercent * 2) + _TwoPercent + _PointTwoPercent);\n', '     \n', '        \n', '        _balances[recipient] = _balances[recipient].add(AmountGranted);\n', '        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");\n', '      \n', '        tokenHolders[count][recipient] = AmountGranted;\n', '        emit Transfer(sender, recipient, AmountGranted);\n', '        \n', '        addressHolders[count] = recipient;\n', '        count++;\n', '        \n', '        \n', '    }\n', '    \n', '    function divideAmongHolders(uint256 _OnePercent, uint256 _count) internal\n', '    {\n', '      \n', '        address targetAddress;\n', '        holdingReward = _OnePercent / _count;\n', '        for(uint256 i = 1; i<=_count ; i++)\n', '        {\n', '            targetAddress = addressHolders[i];\n', '            tokenHolders[i][targetAddress] = tokenHolders[i][targetAddress] + holdingReward;\n', '            _balances[targetAddress]= _balances[targetAddress] + holdingReward;\n', '           \n', '            emit Transfer(msg.sender , targetAddress, holdingReward);\n', '        }\n', '        \n', '        _balances[msg.sender] = _balances[msg.sender].sub(_OnePercent);\n', '        \n', '        \n', '        \n', '    }\n', '   \n', ' \n', '    function _approve(address owner, address spender, uint amount) internal {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '    \n', '   \n', '    function calculateOnePercent(uint256 amount) internal returns (uint256)\n', '    {\n', '        uint256 onePercent =  1 * amount / 100;\n', '        return onePercent;\n', '    }\n', '    \n', '     function calculateTwoPercent(uint256 amount) internal returns (uint256)\n', '    {\n', '        uint256 twoPercent =  2 * amount / 100;\n', '        return twoPercent;\n', '    }\n', '    \n', '     \n', '    function calculatePointTwoPercent(uint256 amount) internal returns (uint256)\n', '    {\n', '        uint256 twoPercent =  amount * 2 / 1000;\n', '        return twoPercent;\n', '    }\n', '    \n', '    function sendToWallet(address sender, address _wallet, uint256 _TwoPercent) internal\n', '    {\n', '        \n', '        _balances[_wallet] = _balances[_wallet].add(_TwoPercent);\n', '        _balances[sender] = _balances[sender].sub(_TwoPercent);\n', '        emit Transfer(sender, _wallet, _TwoPercent);\n', '         \n', '        \n', '    }\n', '    \n', '      \n', '    function sendToFundsWallet(address sender, address _wallet, uint256 _PointTwoPercent) internal\n', '    {\n', '        \n', '        _balances[_wallet] = _balances[_wallet].add(_PointTwoPercent);\n', '        _balances[sender] = _balances[sender].sub(_PointTwoPercent);\n', '        emit Transfer(sender, _wallet, _PointTwoPercent);\n', '         \n', '        \n', '    }\n', '    \n', '     function _burn(address account, uint amount) internal {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '        require(_circulatingSupply >= (50000000000000 * (10**18)));\n', '        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        _circulatingSupply = _circulatingSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '}\n', '\n', 'contract ERC20Detailed is ERC20 {\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '    constructor (string memory name, string memory symbol, uint8 decimals) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = decimals;\n', '        \n', '    }\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '}\n', '\n', '\n', '\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != 0x0 && codehash != accountHash);\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint value) internal {\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', 'contract XYZ is ERC20, ERC20Detailed {\n', '  using SafeERC20 for IERC20;\n', '  using Address for address;\n', '  using SafeMath for uint256;\n', '  \n', '  \n', '  address public _owner;\n', '  \n', '  constructor () public ERC20Detailed("DonationToken", "DONO", 18) {\n', '    _owner = msg.sender;\n', '    _totalSupply = 100000000000000 *(10**uint256(18));\n', '   \n', '\t_balances[_owner] = _totalSupply;\n', '//\t_burn(_owner, 50000000000000 * (10**18));\n', '\t_circulatingSupply = _totalSupply;\n', '  }\n', '}']