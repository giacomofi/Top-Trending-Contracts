['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.5.17;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function decimals() external view returns (uint);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != 0x0 && codehash != accountHash);\n', '    }\n', '    function toPayable(address account) internal pure returns (address payable) {\n', '        return address(uint160(account));\n', '    }\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-call-value\n', '        (bool success, ) = recipient.call.value(amount)("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', 'interface Controller {\n', '    function vaults(address) external view returns (address);\n', '    function rewards() external view returns (address);\n', '}\n', '\n', '/*\n', '\n', ' A strategy must implement the following calls;\n', ' \n', ' - deposit()\n', ' - withdraw(address) must exclude any tokens used in the yield - Controller role - withdraw should return to Controller\n', ' - withdraw(uint) - Controller | Vault role - withdraw should always return to vault\n', ' - withdrawAll() - Controller | Vault role - withdraw should always return to vault\n', ' - balanceOf()\n', ' \n', ' Where possible, strategies must remain as immutable as possible, instead of updating variables, we update the contract by linking it in the controller\n', ' \n', '*/\n', '\n', 'interface Gauge {\n', '    function deposit(uint) external;\n', '    function balanceOf(address) external view returns (uint);\n', '    function withdraw(uint) external;\n', '}\n', '\n', 'interface Mintr {\n', '    function mint(address) external;\n', '}\n', '\n', 'interface Uni {\n', '    function swapExactTokensForTokens(uint, uint, address[] calldata, address, uint) external;\n', '}\n', '\n', 'interface yERC20 {\n', '  function deposit(uint256 _amount) external;\n', '  function withdraw(uint256 _amount) external;\n', '}\n', '\n', 'interface ICurveFi {\n', '\n', '  function get_virtual_price() external view returns (uint);\n', '  function add_liquidity(\n', '    uint256[4] calldata amounts,\n', '    uint256 min_mint_amount\n', '  ) external;\n', '  function remove_liquidity_imbalance(\n', '    uint256[4] calldata amounts,\n', '    uint256 max_burn_amount\n', '  ) external;\n', '  function remove_liquidity(\n', '    uint256 _amount,\n', '    uint256[4] calldata amounts\n', '  ) external;\n', '  function exchange(\n', '    int128 from, int128 to, uint256 _from_amount, uint256 _min_to_amount\n', '  ) external;\n', '}\n', '\n', 'interface VoteEscrow {\n', '    function create_lock(uint, uint) external;\n', '    function increase_amount(uint) external;\n', '    function withdraw() external;\n', '}\n', '\n', 'contract CurveYCRVVoter {\n', '    using SafeERC20 for IERC20;\n', '    using Address for address;\n', '    using SafeMath for uint256;\n', '    \n', '    address constant public want = address(0xdF5e0e81Dff6FAF3A7e52BA697820c5e32D806A8);\n', '    address constant public pool = address(0xFA712EE4788C042e2B7BB55E6cb8ec569C4530c1);\n', '    address constant public mintr = address(0xd061D61a4d941c39E5453435B6345Dc261C2fcE0);\n', '    \n', '    address constant public escrow = address(0x5f3b5DfEb7B28CDbD7FAba78963EE202a494e2A2);\n', '    \n', '    address public governance;\n', '    address public strategy;\n', '    \n', '    constructor() public {\n', '        governance = msg.sender;\n', '    }\n', '    \n', '    function getName() external pure returns (string memory) {\n', '        return "CurveYCRVVoter";\n', '    }\n', '    \n', '    function setStrategy(address _strategy) external {\n', '        require(msg.sender == governance, "!governance");\n', '        strategy = _strategy;\n', '    }\n', '    \n', '    function deposit() public {\n', '        uint _want = IERC20(want).balanceOf(address(this));\n', '        if (_want > 0) {\n', '            IERC20(want).safeApprove(pool, 0);\n', '            IERC20(want).safeApprove(pool, _want);\n', '            Gauge(pool).deposit(_want);\n', '        }\n', '    }\n', '    \n', '    // Controller only function for creating additional rewards from dust\n', '    function withdraw(IERC20 _asset) external returns (uint balance) {\n', '        require(msg.sender == strategy, "!controller");\n', '        balance = _asset.balanceOf(address(this));\n', '        _asset.safeTransfer(strategy, balance);\n', '    }\n', '    \n', '    // Withdraw partial funds, normally used with a vault withdrawal\n', '    function withdraw(uint _amount) external {\n', '        require(msg.sender == strategy, "!controller");\n', '        uint _balance = IERC20(want).balanceOf(address(this));\n', '        if (_balance < _amount) {\n', '            _amount = _withdrawSome(_amount.sub(_balance));\n', '            _amount = _amount.add(_balance);\n', '        }\n', '        IERC20(want).safeTransfer(strategy, _amount);\n', '    }\n', '    \n', '    // Withdraw all funds, normally used when migrating strategies\n', '    function withdrawAll() external returns (uint balance) {\n', '        require(msg.sender == strategy, "!controller");\n', '        _withdrawAll();\n', '        \n', '        \n', '        balance = IERC20(want).balanceOf(address(this));\n', '        IERC20(want).safeTransfer(strategy, balance);\n', '    }\n', '    \n', '    function _withdrawAll() internal {\n', '        Gauge(pool).withdraw(Gauge(pool).balanceOf(address(this)));\n', '    }\n', '    \n', '    function createLock(uint _value, uint _unlockTime) external {\n', '        require(msg.sender == strategy || msg.sender == governance, "!authorized");\n', '        VoteEscrow(escrow).create_lock(_value, _unlockTime);\n', '    }\n', '    \n', '    function increaseAmount(uint _value) external {\n', '        require(msg.sender == strategy || msg.sender == governance, "!authorized");\n', '        VoteEscrow(escrow).increase_amount(_value);\n', '    }\n', '    \n', '    function release() external {\n', '        require(msg.sender == strategy || msg.sender == governance, "!authorized");\n', '        VoteEscrow(escrow).withdraw();\n', '    }\n', '    \n', '    function _withdrawSome(uint256 _amount) internal returns (uint) {\n', '        Gauge(pool).withdraw(_amount);\n', '        return _amount;\n', '    }\n', '    \n', '    function balanceOfWant() public view returns (uint) {\n', '        return IERC20(want).balanceOf(address(this));\n', '    }\n', '    \n', '    function balanceOfPool() public view returns (uint) {\n', '        return Gauge(pool).balanceOf(address(this));\n', '    }\n', '    \n', '    function balanceOf() public view returns (uint) {\n', '        return balanceOfWant()\n', '               .add(balanceOfPool());\n', '    }\n', '    \n', '    function setGovernance(address _governance) external {\n', '        require(msg.sender == governance, "!governance");\n', '        governance = _governance;\n', '    }\n', '    \n', '    function execute(address to, uint value, bytes calldata data) external returns (bool, bytes memory) {\n', '        require(msg.sender == strategy || msg.sender == governance, "!governance");\n', '        (bool success, bytes memory result) = to.call.value(value)(data);\n', '        \n', '        return (success, result);\n', '    }\n', '}']