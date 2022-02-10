['// Dependency file: contracts/libraries/TransferHelper.sol\n', '\n', '//SPDX-License-Identifier: MIT\n', '\n', '// pragma solidity >=0.6.0;\n', '\n', 'library SushiHelper {\n', '    function deposit(address masterChef, uint256 pid, uint256 amount) internal {\n', '        (bool success, bytes memory data) = masterChef.call(abi.encodeWithSelector(0xe2bbb158, pid, amount));\n', '        require(success && data.length == 0, "SushiHelper: DEPOSIT FAILED");\n', '    }\n', '\n', '    function withdraw(address masterChef, uint256 pid, uint256 amount) internal {\n', '        (bool success, bytes memory data) = masterChef.call(abi.encodeWithSelector(0x441a3e70, pid, amount));\n', '        require(success && data.length == 0, "SushiHelper: WITHDRAW FAILED");\n', '    }\n', '\n', '    function pendingSushi(address masterChef, uint256 pid, address user) internal returns (uint256 amount) {\n', '        (bool success, bytes memory data) = masterChef.call(abi.encodeWithSelector(0x195426ec, pid, user));\n', '        require(success && data.length != 0, "SushiHelper: WITHDRAW FAILED");\n', '        amount = abi.decode(data, (uint256));\n', '    }\n', '}\n', '\n', '\n', 'library TransferHelper {\n', '    function safeApprove(address token, address to, uint value) internal {\n', "        // bytes4(keccak256(bytes('approve(address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');\n", '    }\n', '\n', '    function safeTransfer(address token, address to, uint value) internal {\n', "        // bytes4(keccak256(bytes('transfer(address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');\n", '    }\n', '\n', '    function safeTransferFrom(address token, address from, address to, uint value) internal {\n', "        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');\n", '    }\n', '\n', '    function safeTransferETH(address to, uint value) internal {\n', '        (bool success,) = to.call{value:value}(new bytes(0));\n', "        require(success, 'TransferHelper: ETH_TRANSFER_FAILED');\n", '    }\n', '}\n', '\n', '\n', '// Dependency file: contracts/interface/IWasabi.sol\n', '\n', '// pragma solidity >=0.5.0;\n', '\n', 'interface IWasabi {\n', '    function getOffer(address  _lpToken,  uint index) external view returns (address offer);\n', '    function getOfferLength(address _lpToken) external view returns (uint length);\n', '    function pool(address _token) external view returns (uint);\n', '    function increaseProductivity(uint amount) external;\n', '    function decreaseProductivity(uint amount) external;\n', '    function tokenAddress() external view returns(address);\n', '    function addTakerOffer(address _offer, address _user) external returns (uint);\n', '    function getUserOffer(address _user, uint _index) external view returns (address);\n', '    function getUserOffersLength(address _user) external view returns (uint length);\n', '    function getTakerOffer(address _user, uint _index) external view returns (address);\n', '    function getTakerOffersLength(address _user) external view returns (uint length);\n', '    function offerStatus() external view returns(uint amountIn, address masterChef, uint sushiPid);\n', '    function cancel(address _from, address _sushi) external ;\n', '    function take(address taker,uint amountWasabi) external;\n', '    function payback(address _from) external;\n', '    function close(address _from, uint8 _state, address _sushi) external  returns (address tokenToOwner, address tokenToTaker, uint amountToOwner, uint amountToTaker);\n', '    function upgradeGovernance(address _newGovernor) external;\n', '    function acceptToken() external view returns(address);\n', '    function rewardAddress() external view returns(address);\n', '    function getTokensLength() external view returns (uint);\n', '    function tokens(uint _index) external view returns(address);\n', '    function offers(address _offer) external view returns(address tokenIn, address tokenOut, uint amountIn, uint amountOut, uint expire, uint interests, uint duration);\n', '    function getRateForOffer(address _offer) external view returns (uint offerFeeRate, uint offerInterestrate);\n', '}\n', '\n', '\n', '// Dependency file: contracts/interface/IERC20.sol\n', '\n', '// pragma solidity >=0.5.0;\n', '\n', 'interface IERC20 {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external view returns (string memory);\n', '    function symbol() external view returns (string memory);\n', '    function decimals() external view returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '}\n', '\n', '\n', '// Root file: contracts/WasabiGovernance.sol\n', '\n', 'pragma solidity >=0.6.6;\n', '\n', "// import 'contracts/libraries/TransferHelper.sol';\n", "// import 'contracts/interface/IWasabi.sol';\n", "// import 'contracts/interface/IERC20.sol';\n", '\n', '// todo\n', 'contract WasabiGovernance  {\n', '    uint public version = 1;\n', '    address public wasabi;\n', '    address public owner;\n', '\n', '    event OwnerChanged(address indexed _oldOwner, address indexed _newOwner);\n', '    event Upgraded(address indexed _from, address indexed _to, uint _value);\n', '    event RewardManagerChanged(address indexed _from, address indexed _to, uint _rewardTokenBalance, uint _wsbTokenBalance);\n', '\n', '    modifier onlyOwner() {\n', "        require(msg.sender == owner, 'WasabiGovernance: FORBIDDEN');\n", '        _;\n', '    }\n', '\n', '    constructor () public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function initialize(address _wasabi) external onlyOwner {\n', "        require(_wasabi != address(0), 'WasabiGovernance: INPUT_ADDRESS_IS_ZERO');\n", '        wasabi = _wasabi;\n', '    }\n', '\n', '    function changeOwner(address _newOwner) public onlyOwner {\n', "        require(_newOwner != address(0), 'WasabiGovernance: INVALID_ADDRESS');\n", '        emit OwnerChanged(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '\n', '    function upgrade(address _newGovernor) external onlyOwner returns (bool) {\n', '        IWasabi(wasabi).upgradeGovernance(_newGovernor);\n', '        return true; \n', '    }\n', '\n', '    function changeRewardManager(address _manager) external onlyOwner returns (bool) {\n', '        address rewardToken = IWasabi(wasabi).acceptToken();\n', '        address wsbToken = IWasabi(wasabi).tokenAddress();\n', '        uint rewardTokenBalance = IERC20(rewardToken).balanceOf(address(this));\n', '        uint wsbTokenBalance = IERC20(wsbToken).balanceOf(address(this));\n', "        require(rewardTokenBalance > 0 || wsbTokenBalance > 0, 'WasabiGovernance: NO_REWARD');\n", "        require(_manager != address(this), 'WasabiGovernance: NO_CHANGE');\n", '        if (rewardTokenBalance > 0) TransferHelper.safeTransfer(rewardToken, _manager, rewardTokenBalance);\n', '        if (wsbTokenBalance > 0) TransferHelper.safeTransfer(wsbToken, _manager, wsbTokenBalance);\n', '        emit RewardManagerChanged(address(this), _manager, rewardTokenBalance, wsbTokenBalance);\n', '        return true;\n', '    }\n', '\n', '}']