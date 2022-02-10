['// SPDX-License-Identifier: MIT\n', '\n', '/* \n', '\n', '    _    __  __ ____  _     _____ ____       _     _       _       \n', '   / \\  |  \\/  |  _ \\| |   | ____/ ___| ___ | | __| |     (_) ___  \n', '  / _ \\ | |\\/| | |_) | |   |  _|| |  _ / _ \\| |/ _` |     | |/ _ \\ \n', ' / ___ \\| |  | |  __/| |___| |__| |_| | (_) | | (_| |  _  | | (_) |\n', '/_/   \\_\\_|  |_|_|   |_____|_____\\____|\\___/|_|\\__,_| (_) |_|\\___/ \n', '                                                                                                \n', '\n', '    Ample Gold $AMPLG is a goldpegged defi protocol that is based on Ampleforths elastic tokensupply model. \n', '    AMPLG is designed to maintain its base price target of 0.01g of Gold with a progammed inflation adjustment (rebase).\n', '    \n', '    Forked from Ampleforth: https://github.com/ampleforth/uFragments (Credits to Ampleforth team for implementation of rebasing on the ethereum network)\n', '    \n', '    GPL 3.0 license\n', '    \n', '    AMPLG_OTC.sol - AMPLG OTC\n', '  \n', '*/\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', 'contract Initializable {\n', '\n', '  bool private initialized;\n', '  bool private initializing;\n', '\n', '  modifier initializer() {\n', '    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");\n', '\n', '    bool wasInitializing = initializing;\n', '    initializing = true;\n', '    initialized = true;\n', '\n', '    _;\n', '\n', '    initializing = wasInitializing;\n', '  }\n', '\n', '  function isConstructor() private view returns (bool) {\n', '    uint256 cs;\n', '    assembly { cs := extcodesize(address) }\n', '    return cs == 0;\n', '  }\n', '\n', '  uint256[50] private ______gap;\n', '}\n', '\n', 'contract Ownable is Initializable {\n', '\n', '  address private _owner;\n', '  uint256 private _ownershipLocked;\n', '\n', '  event OwnershipLocked(address lockedOwner);\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  function initialize(address sender) internal initializer {\n', '    _owner = sender;\n', '  _ownershipLocked = 0;\n', '  }\n', '\n', '  function owner() public view returns(address) {\n', '    return _owner;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(isOwner());\n', '    _;\n', '  }\n', '\n', '  function isOwner() public view returns(bool) {\n', '    return msg.sender == _owner;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    _transferOwnership(newOwner);\n', '  }\n', '\n', '  function _transferOwnership(address newOwner) internal {\n', '    require(_ownershipLocked == 0);\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '  }\n', '  \n', '  // Set _ownershipLocked flag to lock contract owner forever\n', '  function lockOwnership() public onlyOwner {\n', '  require(_ownershipLocked == 0);\n', '  emit OwnershipLocked(_owner);\n', '    _ownershipLocked = 1;\n', '  }\n', '\n', '  uint256[50] private ______gap;\n', '}\n', '\n', 'library SafeMath {\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'library SafeMathInt {\n', '\n', '    int256 private constant MIN_INT256 = int256(1) << 255;\n', '    int256 private constant MAX_INT256 = ~(int256(1) << 255);\n', '\n', '    function mul(int256 a, int256 b)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        int256 c = a * b;\n', '\n', '        // Detect overflow when multiplying MIN_INT256 with -1\n', '        require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));\n', '        require((b == 0) || (c / b == a));\n', '        return c;\n', '    }\n', '\n', '    function div(int256 a, int256 b)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        // Prevent overflow when dividing MIN_INT256 by -1\n', '        require(b != -1 || a != MIN_INT256);\n', '\n', '        // Solidity already throws when dividing by 0.\n', '        return a / b;\n', '    }\n', '\n', '    function sub(int256 a, int256 b)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        int256 c = a - b;\n', '        require((b >= 0 && c <= a) || (b < 0 && c > a));\n', '        return c;\n', '    }\n', '\n', '    function add(int256 a, int256 b)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        int256 c = a + b;\n', '        require((b >= 0 && c >= a) || (b < 0 && c < a));\n', '        return c;\n', '    }\n', '\n', '    function abs(int256 a)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        require(a != MIN_INT256);\n', '        return a < 0 ? -a : a;\n', '    }\n', '}\n', '\n', '\n', 'interface IAMPLG {\n', '    function totalSupply() external view returns (uint256);\n', '    function rebaseMonetary(uint256 epoch, int256 supplyDelta) external returns (uint256);\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '    function balanceOf(address who) external view returns (uint256);\n', '}\n', '\n', '\n', 'contract AMPLGOTC is Ownable {\n', '    \n', '    using SafeMath for uint256;\n', '    using SafeMathInt for int256;\n', '\n', '\n', '  IAMPLG public token;\n', '  address public wallet;\n', '  uint256 public rate;\n', '  uint256 public weiRaised;\n', '  \n', '  bool public isFunding;\n', '\n', '  event TokenPurchase(\n', '    address indexed purchaser,\n', '    address indexed beneficiary,\n', '    uint256 value,\n', '    uint256 amount\n', '  );\n', '\n', '  constructor(uint256 _rate, address _wallet, IAMPLG _amplg) public {\n', '    Ownable.initialize(msg.sender);\n', '    require(_rate > 0);\n', '    require(_wallet != address(0));\n', '    require(_amplg != address(0));\n', '    rate = _rate;\n', '    wallet = _wallet;\n', '    token = _amplg;\n', '    isFunding = true;\n', '  }\n', '\n', '  function () external payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  function buyTokens(address _beneficiary) public payable {\n', '      require(isFunding);\n', '      uint256 weiAmount = msg.value; \n', '      _preValidatePurchase(_beneficiary, weiAmount);\n', '      uint256 tokens = _getTokenAmount(weiAmount);\n', '      weiRaised = weiRaised.add(weiAmount);\n', '      _processPurchase(_beneficiary, tokens);\n', '      emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);\n', '        _updatePurchasingState(_beneficiary, weiAmount);\n', '        _forwardFunds();\n', '        _postValidatePurchase(_beneficiary, weiAmount);\n', '  }\n', '\n', '  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal { \n', '    require(_beneficiary != address(0));\n', '    require(_weiAmount != 0);\n', '  }\n', '\n', '  function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {\n', '    // optional override\n', '  }\n', '\n', '  function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {\n', '    token.transfer(_beneficiary, _tokenAmount);\n', '  }\n', '\n', '  function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {\n', '    _deliverTokens(_beneficiary, _tokenAmount);\n', '  }\n', '\n', '  function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {\n', '    // optional override\n', '  }\n', '\n', '  function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {\n', '        uint256 tokenDecimals = 9;\n', '        uint256 etherDecimals = 18;\n', '\n', '        if (tokenDecimals < etherDecimals) {\n', '            return _weiAmount.mul(rate).div(10 ** (etherDecimals.sub(tokenDecimals)));\n', '        }\n', '\n', '        if (tokenDecimals > etherDecimals) {\n', '            return _weiAmount.mul(rate).mul(10 ** (tokenDecimals.sub(etherDecimals)));\n', '        }\n', '\n', '        return _weiAmount.mul(rate);\n', '  }\n', '  \n', '  function _forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '  \n', '  function getBalance() public view returns (uint256) {\n', '      address _address = this;\n', '      return token.balanceOf(_address);\n', '      \n', '  }\n', '  \n', '   function setStatusOTC(bool _status) \n', '   external \n', '   onlyOwner \n', '   {\n', '      require(msg.sender == Ownable.owner());\n', '      isFunding = _status;\n', '    }\n', '  \n', '  function setRate(uint256 _rate) \n', '   external \n', '   onlyOwner \n', '   {\n', '      require(msg.sender == Ownable.owner());\n', '      rate = _rate;\n', '    }\n', '  \n', '  function collectUnsoldAfterOTC() \n', '  external\n', '  onlyOwner\n', '  {\n', '        isFunding = false;\n', '        uint256 remaining = token.balanceOf(this);\n', '        token.transfer(msg.sender, remaining);\n', '  }\n', '    \n', '    \n', '  function burnTokens(address _tokenAddress, uint _amount) \n', '  external\n', '  onlyOwner\n', '  {\n', '        isFunding = false;\n', '        token.transfer(_tokenAddress, _amount);\n', '  }\n', '    \n', '}']