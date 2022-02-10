['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.5.17;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function decimals() external view returns (uint);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != 0x0 && codehash != accountHash);\n', '    }\n', '    function toPayable(address account) internal pure returns (address payable) {\n', '        return address(uint160(account));\n', '    }\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-call-value\n', '        (bool success, ) = recipient.call.value(amount)("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', 'interface Controller {\n', '    function vaults(address) external view returns (address);\n', '    function rewards() external view returns (address);\n', '}\n', '\n', '/*\n', '\n', ' A strategy must implement the following calls;\n', ' \n', ' - deposit()\n', ' - withdraw(address) must exclude any tokens used in the yield - Controller role - withdraw should return to Controller\n', ' - withdraw(uint) - Controller | Vault role - withdraw should always return to vault\n', ' - withdrawAll() - Controller | Vault role - withdraw should always return to vault\n', ' - balanceOf()\n', ' \n', ' Where possible, strategies must remain as immutable as possible, instead of updating variables, we update the contract by linking it in the controller\n', ' \n', '*/\n', '\n', 'interface yERC20 {\n', '  function deposit(uint) external;\n', '  function withdraw(uint) external;\n', '  function getPricePerFullShare() external view returns (uint);\n', '}\n', '\n', 'interface ICurveFi {\n', '\n', '  function get_virtual_price() external view returns (uint);\n', '  function add_liquidity(\n', '    uint256[4] calldata amounts,\n', '    uint256 min_mint_amount\n', '  ) external;\n', '  function remove_liquidity_imbalance(\n', '    uint256[4] calldata amounts,\n', '    uint256 max_burn_amount\n', '  ) external;\n', '  function remove_liquidity(\n', '    uint256 _amount,\n', '    uint256[4] calldata amounts\n', '  ) external;\n', '  function exchange(\n', '    int128 from, int128 to, uint256 _from_amount, uint256 _min_to_amount\n', '  ) external;\n', '}\n', '\n', 'contract StrategyTUSDCurve {\n', '    using SafeERC20 for IERC20;\n', '    using Address for address;\n', '    using SafeMath for uint256;\n', '    \n', '    address constant public want = address(0x0000000000085d4780B73119b644AE5ecd22b376);\n', '    address constant public y = address(0x73a052500105205d34Daf004eAb301916DA8190f);\n', '    address constant public ycrv = address(0xdF5e0e81Dff6FAF3A7e52BA697820c5e32D806A8);\n', '    address constant public yycrv = address(0x5dbcF33D8c2E976c6b560249878e6F1491Bca25c);\n', '    address constant public curve = address(0x45F783CCE6B7FF23B2ab2D70e416cdb7D6055f51);\n', '    \n', '    address constant public dai = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);\n', '    address constant public ydai = address(0x16de59092dAE5CcF4A1E6439D611fd0653f0Bd01);\n', '\n', '    address constant public usdc = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);\n', '    address constant public yusdc = address(0xd6aD7a6750A7593E092a9B218d66C0A814a3436e);\n', '\n', '    address constant public usdt = address(0xdAC17F958D2ee523a2206206994597C13D831ec7);\n', '    address constant public yusdt = address(0x83f798e925BcD4017Eb265844FDDAbb448f1707D);\n', '\n', '    address constant public tusd = address(0x0000000000085d4780B73119b644AE5ecd22b376);\n', '    address constant public ytusd = address(0x73a052500105205d34Daf004eAb301916DA8190f);\n', '\n', '    \n', '    address public governance;\n', '    address public controller;\n', '    \n', '    constructor(address _controller) public {\n', '        governance = msg.sender;\n', '        controller = _controller;\n', '    }\n', '    \n', '    function getName() external pure returns (string memory) {\n', '        return "StrategyTUSDCurve";\n', '    }\n', '    \n', '    function deposit() public {\n', '        uint _want = IERC20(want).balanceOf(address(this));\n', '        if (_want > 0) {\n', '            IERC20(want).safeApprove(y, 0);\n', '            IERC20(want).safeApprove(y, _want);\n', '            yERC20(y).deposit(_want);\n', '        }\n', '        uint _y = IERC20(y).balanceOf(address(this));\n', '        if (_y > 0) {\n', '            IERC20(y).safeApprove(curve, 0);\n', '            IERC20(y).safeApprove(curve, _y);\n', '            ICurveFi(curve).add_liquidity([0,0,0,_y],0);\n', '        }\n', '        \n', '    }\n', '    \n', '    // Controller only function for creating additional rewards from dust\n', '    function withdraw(IERC20 _asset) external returns (uint balance) {\n', '        require(msg.sender == controller, "!controller");\n', '        require(want != address(_asset), "want");\n', '        require(y != address(_asset), "y");\n', '        require(ycrv != address(_asset), "ycrv");\n', '        require(yycrv != address(_asset), "yycrv");\n', '        balance = _asset.balanceOf(address(this));\n', '        _asset.safeTransfer(controller, balance);\n', '    }\n', '    \n', '    // Withdraw partial funds, normally used with a vault withdrawal\n', '    function withdraw(uint _amount) external {\n', '        require(msg.sender == controller, "!controller");\n', '        uint _balance = IERC20(want).balanceOf(address(this));\n', '        if (_balance < _amount) {\n', '            _amount = _withdrawSome(_amount.sub(_balance));\n', '            _amount = _amount.add(_balance);\n', '        }\n', '        \n', '        /*\n', '        address _vault = Controller(controller).vaults(address(want));\n', '        require(_vault != address(0), "!vault"); // additional protection so we don\'t burn the funds\n', '        IERC20(want).safeTransfer(_vault, _amount);\n', '        */\n', '        IERC20(want).safeTransfer(controller, _amount);\n', '    }\n', '    \n', '    // Withdraw all funds, normally used when migrating strategies\n', '    function withdrawAll() external returns (uint balance) {\n', '        require(msg.sender == controller, "!controller");\n', '        _withdrawAll();\n', '        \n', '        \n', '        balance = IERC20(want).balanceOf(address(this));\n', '        \n', '        /*\n', '        address _vault = Controller(controller).vaults(address(want));\n', '        require(_vault != address(0), "!vault"); // additional protection so we don\'t burn the funds\n', '        IERC20(want).safeTransfer(_vault, balance);\n', '        */\n', '        \n', '        IERC20(want).safeTransfer(controller, balance);\n', '    }\n', '    \n', '    function withdrawTUSD(uint256 _amount) internal returns (uint) {\n', '        IERC20(ycrv).safeApprove(curve, 0);\n', '        IERC20(ycrv).safeApprove(curve, _amount);\n', '        ICurveFi(curve).remove_liquidity(_amount, [uint256(0),0,0,0]);\n', '    \n', '        uint256 _ydai = IERC20(ydai).balanceOf(address(this));\n', '        uint256 _yusdc = IERC20(yusdc).balanceOf(address(this));\n', '        uint256 _yusdt = IERC20(yusdt).balanceOf(address(this));\n', '    \n', '        if (_ydai > 0) {\n', '            IERC20(ydai).safeApprove(curve, 0);\n', '            IERC20(ydai).safeApprove(curve, _ydai);\n', '            ICurveFi(curve).exchange(0, 3, _ydai, 0);\n', '        }\n', '        if (_yusdc > 0) {\n', '            IERC20(yusdc).safeApprove(curve, 0);\n', '            IERC20(yusdc).safeApprove(curve, _yusdc);\n', '            ICurveFi(curve).exchange(1, 3, _yusdc, 0);\n', '        }\n', '        if (_yusdt > 0) {\n', '            IERC20(yusdt).safeApprove(curve, 0);\n', '            IERC20(yusdt).safeApprove(curve, _yusdt);\n', '            ICurveFi(curve).exchange(2, 3, _yusdt, 0);\n', '        }\n', '        \n', '        uint _before = IERC20(want).balanceOf(address(this));\n', '        yERC20(ytusd).withdraw(IERC20(ytusd).balanceOf(address(this)));\n', '        uint _after = IERC20(want).balanceOf(address(this));\n', '        \n', '        return _after.sub(_before);\n', '    }\n', '    \n', '    function _withdrawAll() internal {\n', '        yERC20(yycrv).withdraw(IERC20(yycrv).balanceOf(address(this)));\n', '        withdrawTUSD(IERC20(ycrv).balanceOf(address(this)));\n', '    }\n', '    \n', '    function _withdrawSome(uint256 _amount) internal returns (uint) {\n', '        // calculate amount of ycrv to withdraw for amount of _want_\n', '        uint _ycrv = _amount.mul(1e18).div(ICurveFi(curve).get_virtual_price());\n', '        // calculate amount of yycrv to withdraw for amount of _ycrv_\n', '        uint _yycrv = _ycrv.mul(1e18).div(yERC20(yycrv).getPricePerFullShare());\n', '        uint _before = IERC20(ycrv).balanceOf(address(this));\n', '        yERC20(yycrv).withdraw(_yycrv);\n', '        uint _after = IERC20(ycrv).balanceOf(address(this));\n', '        return withdrawTUSD(_after.sub(_before));\n', '    }\n', '    \n', '    function balanceOfWant() public view returns (uint) {\n', '        return IERC20(want).balanceOf(address(this));\n', '    }\n', '    \n', '    function balanceOfYYCRV() public view returns (uint) {\n', '        return IERC20(yycrv).balanceOf(address(this));\n', '    }\n', '    \n', '    function balanceOfYYCRVinYCRV() public view returns (uint) {\n', '        return balanceOfYYCRV().mul(yERC20(yycrv).getPricePerFullShare()).div(1e18);\n', '    }\n', '    \n', '    function balanceOfYYCRVinTUSD() public view returns (uint) {\n', '        return balanceOfYYCRVinYCRV().mul(ICurveFi(curve).get_virtual_price()).div(1e18);\n', '    }\n', '    \n', '    function balanceOfYCRV() public view returns (uint) {\n', '        return IERC20(ycrv).balanceOf(address(this));\n', '    }\n', '    \n', '    function balanceOfYCRVTUSD() public view returns (uint) {\n', '        return balanceOfYCRV().mul(ICurveFi(curve).get_virtual_price()).div(1e18);\n', '    }\n', '    \n', '    function balanceOf() public view returns (uint) {\n', '        return balanceOfWant()\n', '               .add(balanceOfYYCRVinTUSD());\n', '    }\n', '    \n', '    function setGovernance(address _governance) external {\n', '        require(msg.sender == governance, "!governance");\n', '        governance = _governance;\n', '    }\n', '    \n', '    function setController(address _controller) external {\n', '        require(msg.sender == governance, "!governance");\n', '        controller = _controller;\n', '    }\n', '}']