['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.5.17;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function decimals() external view returns (uint);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != 0x0 && codehash != accountHash);\n', '    }\n', '    function toPayable(address account) internal pure returns (address payable) {\n', '        return address(uint160(account));\n', '    }\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-call-value\n', '        (bool success, ) = recipient.call.value(amount)("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', 'interface Controller {\n', '    function vaults(address) external view returns (address);\n', '    function rewards() external view returns (address);\n', '}\n', '\n', '/*\n', '\n', ' A strategy must implement the following calls;\n', ' \n', ' - deposit()\n', ' - withdraw(address) must exclude any tokens used in the yield - Controller role - withdraw should return to Controller\n', ' - withdraw(uint) - Controller | Vault role - withdraw should always return to vault\n', ' - withdrawAll() - Controller | Vault role - withdraw should always return to vault\n', ' - balanceOf()\n', ' \n', ' Where possible, strategies must remain as immutable as possible, instead of updating variables, we update the contract by linking it in the controller\n', ' \n', '*/\n', '\n', 'interface Gauge {\n', '    function deposit(uint) external;\n', '    function balanceOf(address) external view returns (uint);\n', '    function withdraw(uint) external;\n', '}\n', '\n', 'interface Mintr {\n', '    function mint(address) external;\n', '}\n', '\n', 'interface Uni {\n', '    function swapExactTokensForTokens(uint, uint, address[] calldata, address, uint) external;\n', '}\n', '\n', 'interface yERC20 {\n', '  function deposit(uint256 _amount) external;\n', '  function withdraw(uint256 _amount) external;\n', '}\n', '\n', 'interface ICurveFi {\n', '\n', '  function get_virtual_price() external view returns (uint);\n', '  function add_liquidity(\n', '    uint256[4] calldata amounts,\n', '    uint256 min_mint_amount\n', '  ) external;\n', '  function remove_liquidity_imbalance(\n', '    uint256[4] calldata amounts,\n', '    uint256 max_burn_amount\n', '  ) external;\n', '  function remove_liquidity(\n', '    uint256 _amount,\n', '    uint256[4] calldata amounts\n', '  ) external;\n', '  function exchange(\n', '    int128 from, int128 to, uint256 _from_amount, uint256 _min_to_amount\n', '  ) external;\n', '}\n', '\n', 'interface VoterProxy {\n', '    function withdraw(address _gauge, address _token, uint _amount) external returns (uint);\n', '    function balanceOf(address _gauge) external view returns (uint);\n', '    function withdrawAll(address _gauge, address _token) external returns (uint);\n', '    function deposit(address _gauge, address _token) external;\n', '    function harvest(address _gauge) external;\n', '}\n', '\n', 'contract StrategyCurveYBUSDProxy {\n', '    using SafeERC20 for IERC20;\n', '    using Address for address;\n', '    using SafeMath for uint256;\n', '    \n', '    address constant public want = address(0x3B3Ac5386837Dc563660FB6a0937DFAa5924333B);\n', '    address constant public crv = address(0xD533a949740bb3306d119CC777fa900bA034cd52);\n', '    address constant public uni = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n', '    address constant public weth = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2); // used for crv <> weth <> dai route\n', '    \n', '    address constant public dai = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);\n', '    address constant public ydai = address(0xC2cB1040220768554cf699b0d863A3cd4324ce32);\n', '    address constant public curve = address(0x79a8C46DeA5aDa233ABaFFD40F3A0A2B1e5A4F27);\n', '    \n', '    address constant public gauge = address(0x69Fb7c45726cfE2baDeE8317005d3F94bE838840);\n', '    address constant public proxy = address(0x5886E475e163f78CF63d6683AbC7fe8516d12081);\n', '    \n', '    uint public performanceFee = 500;\n', '    uint constant public performanceMax = 10000;\n', '    \n', '    uint public withdrawalFee = 50;\n', '    uint constant public withdrawalMax = 10000;\n', '    \n', '    address public governance;\n', '    address public controller;\n', '    address public strategist;\n', '    \n', '    constructor(address _controller) public {\n', '        governance = msg.sender;\n', '        strategist = msg.sender;\n', '        controller = _controller;\n', '    }\n', '    \n', '    function getName() external pure returns (string memory) {\n', '        return "StrategyCurveYBUSDProxy";\n', '    }\n', '    \n', '    function setStrategist(address _strategist) external {\n', '        require(msg.sender == governance, "!governance");\n', '        strategist = _strategist;\n', '    }\n', '    \n', '    function setWithdrawalFee(uint _withdrawalFee) external {\n', '        require(msg.sender == governance, "!governance");\n', '        withdrawalFee = _withdrawalFee;\n', '    }\n', '    \n', '    function setPerformanceFee(uint _performanceFee) external {\n', '        require(msg.sender == governance, "!governance");\n', '        performanceFee = _performanceFee;\n', '    }\n', '    \n', '    function deposit() public {\n', '        uint _want = IERC20(want).balanceOf(address(this));\n', '        if (_want > 0) {\n', '            IERC20(want).safeTransfer(proxy, _want);\n', '            VoterProxy(proxy).deposit(gauge, want);\n', '        }\n', '    }\n', '    \n', '    // Controller only function for creating additional rewards from dust\n', '    function withdraw(IERC20 _asset) external returns (uint balance) {\n', '        require(msg.sender == controller, "!controller");\n', '        require(want != address(_asset), "want");\n', '        require(crv != address(_asset), "crv");\n', '        require(ydai != address(_asset), "ydai");\n', '        require(dai != address(_asset), "dai");\n', '        balance = _asset.balanceOf(address(this));\n', '        _asset.safeTransfer(controller, balance);\n', '    }\n', '    \n', '    // Withdraw partial funds, normally used with a vault withdrawal\n', '    function withdraw(uint _amount) external {\n', '        require(msg.sender == controller, "!controller");\n', '        uint _balance = IERC20(want).balanceOf(address(this));\n', '        if (_balance < _amount) {\n', '            _amount = _withdrawSome(_amount.sub(_balance));\n', '            _amount = _amount.add(_balance);\n', '        }\n', '        \n', '        /*\n', '        uint _fee = _amount.mul(withdrawalFee).div(withdrawalMax);\n', '        \n', '        \n', '        IERC20(want).safeTransfer(Controller(controller).rewards(), _fee);\n', '        address _vault = Controller(controller).vaults(address(want));\n', '        require(_vault != address(0), "!vault"); // additional protection so we don\'t burn the funds\n', '        \n', '        IERC20(want).safeTransfer(_vault, _amount.sub(_fee));\n', '        */\n', '        IERC20(want).safeTransfer(controller, _amount);\n', '    }\n', '    \n', '    // Withdraw all funds, normally used when migrating strategies\n', '    function withdrawAll() external returns (uint balance) {\n', '        require(msg.sender == controller, "!controller");\n', '        _withdrawAll();\n', '        \n', '        \n', '        balance = IERC20(want).balanceOf(address(this));\n', '        /*\n', '        address _vault = Controller(controller).vaults(address(want));\n', '        require(_vault != address(0), "!vault"); // additional protection so we don\'t burn the funds\n', '        IERC20(want).safeTransfer(_vault, balance);\n', '        */\n', '        IERC20(want).safeTransfer(controller, balance);\n', '    }\n', '    \n', '    function _withdrawAll() internal {\n', '        VoterProxy(proxy).withdrawAll(gauge, want);\n', '    }\n', '    \n', '    function harvest() public {\n', '        require(msg.sender == strategist || msg.sender == governance, "!authorized");\n', '        VoterProxy(proxy).harvest(gauge);\n', '        uint _crv = IERC20(crv).balanceOf(address(this));\n', '        if (_crv > 0) {\n', '            IERC20(crv).safeApprove(uni, 0);\n', '            IERC20(crv).safeApprove(uni, _crv);\n', '            \n', '            address[] memory path = new address[](3);\n', '            path[0] = crv;\n', '            path[1] = weth;\n', '            path[2] = dai;\n', '            \n', '            Uni(uni).swapExactTokensForTokens(_crv, uint(0), path, address(this), now.add(1800));\n', '        }\n', '        uint _dai = IERC20(dai).balanceOf(address(this));\n', '        if (_dai > 0) {\n', '            IERC20(dai).safeApprove(ydai, 0);\n', '            IERC20(dai).safeApprove(ydai, _dai);\n', '            yERC20(ydai).deposit(_dai);\n', '        }\n', '        uint _ydai = IERC20(ydai).balanceOf(address(this));\n', '        if (_ydai > 0) {\n', '            IERC20(ydai).safeApprove(curve, 0);\n', '            IERC20(ydai).safeApprove(curve, _ydai);\n', '            ICurveFi(curve).add_liquidity([_ydai,0,0,0],0);\n', '        }\n', '        uint _want = IERC20(want).balanceOf(address(this));\n', '        if (_want > 0) {\n', '            //uint _fee = _want.mul(performanceFee).div(performanceMax);\n', '            //IERC20(want).safeTransfer(Controller(controller).rewards(), _fee);\n', '            deposit();\n', '        }\n', '    }\n', '    \n', '    function _withdrawSome(uint256 _amount) internal returns (uint) {\n', '        return VoterProxy(proxy).withdraw(gauge, want, _amount);\n', '    }\n', '    \n', '    function balanceOfWant() public view returns (uint) {\n', '        return IERC20(want).balanceOf(address(this));\n', '    }\n', '    \n', '    function balanceOfPool() public view returns (uint) {\n', '        return VoterProxy(proxy).balanceOf(gauge);\n', '    }\n', '    \n', '    function balanceOf() public view returns (uint) {\n', '        return balanceOfWant()\n', '               .add(balanceOfPool());\n', '    }\n', '    \n', '    function setGovernance(address _governance) external {\n', '        require(msg.sender == governance, "!governance");\n', '        governance = _governance;\n', '    }\n', '    \n', '    function setController(address _controller) external {\n', '        require(msg.sender == governance, "!governance");\n', '        controller = _controller;\n', '    }\n', '}']