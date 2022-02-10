['pragma solidity ^0.5.16;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != 0x0 && codehash != accountHash);\n', '    }\n', '    function toPayable(address account) internal pure returns (address payable) {\n', '        return address(uint160(account));\n', '    }\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-call-value\n', '        (bool success, ) = recipient.call.value(amount)("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', 'interface Strategy {\n', '    function want() external view returns (address);\n', '    function deposit() external;\n', '    function withdraw(address) external;\n', '    function withdraw(uint) external;\n', '    function withdrawAll() external returns (uint);\n', '    function balanceOf() external view returns (uint);\n', '}\n', '\n', 'interface Converter {\n', '    function convert(address) external returns (uint);\n', '}\n', '\n', 'interface OneSplitAudit {\n', '    function swap(\n', '        address fromToken,\n', '        address destToken,\n', '        uint256 amount,\n', '        uint256 minReturn,\n', '        uint256[] calldata distribution,\n', '        uint256 flags\n', '    )\n', '    external\n', '    payable\n', '    returns(uint256 returnAmount);\n', '\n', '    function getExpectedReturn(\n', '        address fromToken,\n', '        address destToken,\n', '        uint256 amount,\n', '        uint256 parts,\n', '        uint256 flags // See constants in IOneSplit.sol\n', '    )\n', '    external\n', '    view\n', '    returns(\n', '        uint256 returnAmount,\n', '        uint256[] memory distribution\n', '    );\n', '}\n', '\n', 'contract Controller {\n', '    using SafeERC20 for IERC20;\n', '    using Address for address;\n', '    using SafeMath for uint256;\n', '\n', '    address public governance;\n', '    address public strategist;\n', '\n', '    address public onesplit;\n', '    address public rewards;\n', '    mapping(address => address) public vaults;\n', '    mapping(address => address) public strategies;\n', '    mapping(address => mapping(address => address)) public converters;\n', '\n', '    mapping(address => mapping(address => bool)) public approvedStrategies;\n', '\n', '    uint public split = 500;\n', '    uint public constant max = 10000;\n', '\n', '    constructor(address _rewards) public {\n', '        governance = msg.sender;\n', '        strategist = msg.sender;\n', '        onesplit = address(0x50FDA034C0Ce7a8f7EFDAebDA7Aa7cA21CC1267e);\n', '        rewards = _rewards;\n', '    }\n', '\n', '    function setRewards(address _rewards) public {\n', '        require(msg.sender == governance, "!governance");\n', '        rewards = _rewards;\n', '    }\n', '\n', '    function setStrategist(address _strategist) public {\n', '        require(msg.sender == governance, "!governance");\n', '        strategist = _strategist;\n', '    }\n', '\n', '    function setSplit(uint _split) public {\n', '        require(msg.sender == governance, "!governance");\n', '        split = _split;\n', '    }\n', '\n', '    function setOneSplit(address _onesplit) public {\n', '        require(msg.sender == governance, "!governance");\n', '        onesplit = _onesplit;\n', '    }\n', '\n', '    function setGovernance(address _governance) public {\n', '        require(msg.sender == governance, "!governance");\n', '        governance = _governance;\n', '    }\n', '\n', '    function setVault(address _token, address _vault) public {\n', '        require(msg.sender == strategist || msg.sender == governance, "!strategist");\n', '        require(vaults[_token] == address(0), "vault");\n', '        vaults[_token] = _vault;\n', '    }\n', '\n', '    function approveStrategy(address _token, address _strategy) public {\n', '        require(msg.sender == governance, "!governance");\n', '        approvedStrategies[_token][_strategy] = true;\n', '    }\n', '\n', '    function revokeStrategy(address _token, address _strategy) public {\n', '        require(msg.sender == governance, "!governance");\n', '        approvedStrategies[_token][_strategy] = false;\n', '    }\n', '\n', '    function setConverter(address _input, address _output, address _converter) public {\n', '        require(msg.sender == strategist || msg.sender == governance, "!strategist");\n', '        converters[_input][_output] = _converter;\n', '    }\n', '\n', '    function setStrategy(address _token, address _strategy) public {\n', '        require(msg.sender == strategist || msg.sender == governance, "!strategist");\n', '        require(approvedStrategies[_token][_strategy] == true, "!approved");\n', '\n', '        address _current = strategies[_token];\n', '        if (_current != address(0)) {\n', '            Strategy(_current).withdrawAll();\n', '        }\n', '        strategies[_token] = _strategy;\n', '    }\n', '\n', '    function earn(address _token, uint _amount) public {\n', '        address _strategy = strategies[_token];\n', '        address _want = Strategy(_strategy).want();\n', '        if (_want != _token) {\n', '            address converter = converters[_token][_want];\n', '            IERC20(_token).safeTransfer(converter, _amount);\n', '            _amount = Converter(converter).convert(_strategy);\n', '            IERC20(_want).safeTransfer(_strategy, _amount);\n', '        } else {\n', '            IERC20(_token).safeTransfer(_strategy, _amount);\n', '        }\n', '        Strategy(_strategy).deposit();\n', '    }\n', '\n', '    function balanceOf(address _token) external view returns (uint) {\n', '        return Strategy(strategies[_token]).balanceOf();\n', '    }\n', '\n', '    function withdrawAll(address _token) public {\n', '        require(msg.sender == strategist || msg.sender == governance, "!strategist");\n', '        Strategy(strategies[_token]).withdrawAll();\n', '    }\n', '\n', '    function inCaseTokensGetStuck(address _token, uint _amount) public {\n', '        require(msg.sender == strategist || msg.sender == governance, "!governance");\n', '        IERC20(_token).safeTransfer(msg.sender, _amount);\n', '    }\n', '\n', '    function inCaseStrategyTokenGetStuck(address _strategy, address _token) public {\n', '        require(msg.sender == strategist || msg.sender == governance, "!governance");\n', '        Strategy(_strategy).withdraw(_token);\n', '    }\n', '\n', '    function getExpectedReturn(address _strategy, address _token, uint parts) public view returns (uint expected) {\n', '        uint _balance = IERC20(_token).balanceOf(_strategy);\n', '        address _want = Strategy(_strategy).want();\n', '        (expected,) = OneSplitAudit(onesplit).getExpectedReturn(_token, _want, _balance, parts, 0);\n', '    }\n', '\n', '    // Only allows to withdraw non-core strategy tokens ~ this is over and above normal yield\n', '    function yearn(address _strategy, address _token, uint parts) public {\n', '        require(msg.sender == strategist || msg.sender == governance, "!governance");\n', '        // This contract should never have value in it, but just incase since this is a public call\n', '        uint _before = IERC20(_token).balanceOf(address(this));\n', '        Strategy(_strategy).withdraw(_token);\n', '        uint _after =  IERC20(_token).balanceOf(address(this));\n', '        if (_after > _before) {\n', '            uint _amount = _after.sub(_before);\n', '            address _want = Strategy(_strategy).want();\n', '            uint[] memory _distribution;\n', '            uint _expected;\n', '            _before = IERC20(_want).balanceOf(address(this));\n', '            IERC20(_token).safeApprove(onesplit, 0);\n', '            IERC20(_token).safeApprove(onesplit, _amount);\n', '            (_expected, _distribution) = OneSplitAudit(onesplit).getExpectedReturn(_token, _want, _amount, parts, 0);\n', '            OneSplitAudit(onesplit).swap(_token, _want, _amount, _expected, _distribution, 0);\n', '            _after = IERC20(_want).balanceOf(address(this));\n', '            if (_after > _before) {\n', '                _amount = _after.sub(_before);\n', '                uint _reward = _amount.mul(split).div(max);\n', '                earn(_want, _amount.sub(_reward));\n', '                IERC20(_want).safeTransfer(rewards, _reward);\n', '            }\n', '        }\n', '    }\n', '\n', '    function withdraw(address _token, uint _amount) public {\n', '        require(msg.sender == vaults[_token], "!vault");\n', '        Strategy(strategies[_token]).withdraw(_amount);\n', '    }\n', '}']