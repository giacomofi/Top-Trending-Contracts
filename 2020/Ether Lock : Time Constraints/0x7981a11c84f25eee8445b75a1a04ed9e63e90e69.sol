['pragma solidity ^0.5.16;\n', '\n', 'contract SGCDEXETHSwap {\n', '\n', '  using SafeMath for uint;\n', '\n', '  address public owner;\n', '  address payable exchangeFeeAddress;\n', '  uint256 exchangeFee;\n', '  uint256 SafeTime = 2 hours; // atomic swap timeOut\n', '\n', '  struct Swap {\n', '    address payable targetWallet;\n', '    bytes32 secret;\n', '    bytes20 secretHash;\n', '    uint256 createdAt;\n', '    uint256 balance;\n', '  }\n', '\n', '  // ETH Owner => BTC Owner => Swap\n', '  mapping(address => mapping(address => Swap)) public swaps;\n', '  mapping(address => mapping(address => uint)) public participantSigns;\n', '\n', '  constructor () public {\n', '    owner = msg.sender;\n', '    exchangeFee = 1000;\n', '    exchangeFeeAddress = 0x264Ea0F0edCf7D471b41c12540183bc38236Aec6;\n', '  }\n', '\n', '  function updateExchangeFeeAddress (address payable newAddress) public returns (bool status) {\n', '    require(owner == msg.sender);\n', '    exchangeFeeAddress = newAddress;\n', '    return true;\n', '  }\n', '\n', '  function updateExchangeFee (uint256 newExchangeFee) public returns (bool status) {\n', '    require(owner == msg.sender);\n', '    exchangeFee = newExchangeFee;\n', '    return true;\n', '  }\n', '\n', '  event CreateSwap(address _buyer, address _seller, uint256 _value, bytes20 _secretHash, uint256 createdAt);\n', '\n', '  // ETH Owner creates Swap with secretHash\n', '  // ETH Owner make Ether deposit\n', '  function createSwap(bytes20 _secretHash, address payable _participantAddress) public payable {\n', '    require(msg.value > 0);\n', '    require(swaps[msg.sender][_participantAddress].balance == uint256(0));\n', '\n', '    swaps[msg.sender][_participantAddress] = Swap(\n', '      _participantAddress,\n', '      bytes32(0),\n', '      _secretHash,\n', '      now,\n', '      msg.value\n', '    );\n', '\n', '    emit CreateSwap(_participantAddress, msg.sender, msg.value, _secretHash, now);\n', '  }\n', '\n', '  // ETH Owner creates Swap with secretHash\n', '  // ETH Owner make Ether deposit\n', '  function createSwapTarget(bytes20 _secretHash, address payable _participantAddress, address payable _targetWallet) public payable {\n', '    require(msg.value > 0);\n', '    require(swaps[msg.sender][_participantAddress].balance == uint256(0));\n', '\n', '    swaps[msg.sender][_participantAddress] = Swap(\n', '      _targetWallet,\n', '      bytes32(0),\n', '      _secretHash,\n', '      now,\n', '      msg.value\n', '    );\n', '\n', '    emit CreateSwap(_participantAddress, msg.sender, msg.value, _secretHash, now);\n', '  }\n', '\n', '  function getBalance(address _ownerAddress) public view returns (uint256) {\n', '    return swaps[_ownerAddress][msg.sender].balance;\n', '  }\n', '\n', '  // Get target wallet (buyer check)\n', '  function getTargetWallet(address _ownerAddress) public view returns (address) {\n', '      return swaps[_ownerAddress][msg.sender].targetWallet;\n', '  }\n', '\n', '  event Withdraw(address _buyer, address _seller, bytes20 _secretHash, uint256 withdrawnAt);\n', '\n', '  // BTC Owner withdraw money and adds secret key to swap\n', '  // BTC Owner receive +1 reputation\n', '  function withdraw(bytes32 _secret, address _ownerAddress) public {\n', '    Swap memory swap = swaps[_ownerAddress][msg.sender];\n', '\n', '    require(swap.secretHash == ripemd160(abi.encodePacked(_secret)));\n', '    require(swap.balance > uint256(0));\n', '    require(swap.createdAt.add(SafeTime) > now);\n', '\n', '    uint256 actualValue = swap.balance;\n', '    uint256 tradeFee = actualValue.div(exchangeFee);\n', '    uint256 balanceAfterDeduction = actualValue.sub(tradeFee);\n', '\n', '    swap.targetWallet.transfer(balanceAfterDeduction);\n', '    exchangeFeeAddress.transfer(tradeFee);\n', '\n', '    swaps[_ownerAddress][msg.sender].balance = 0;\n', '    swaps[_ownerAddress][msg.sender].secret = _secret;\n', '\n', '    emit Withdraw(msg.sender, _ownerAddress, swap.secretHash, now);\n', '  }\n', '  // BTC Owner withdraw money and adds secret key to swap\n', '  // BTC Owner receive +1 reputation\n', '  function withdrawNoMoney(bytes32 _secret, address participantAddress) public {\n', '    Swap memory swap = swaps[msg.sender][participantAddress];\n', '\n', '    require(swap.secretHash == ripemd160(abi.encodePacked(_secret)));\n', '    require(swap.balance > uint256(0));\n', '    require(swap.createdAt.add(SafeTime) > now);\n', '\n', '    uint256 actualValue = swap.balance;\n', '    uint256 tradeFee = actualValue.div(10**2).mul(exchangeFee);\n', '    uint256 balanceAfterDeduction = actualValue.sub(tradeFee);\n', '\n', '    swap.targetWallet.transfer(balanceAfterDeduction);\n', '    exchangeFeeAddress.transfer(tradeFee);\n', '\n', '    swaps[msg.sender][participantAddress].balance = 0;\n', '    swaps[msg.sender][participantAddress].secret = _secret;\n', '\n', '    emit Withdraw(participantAddress, msg.sender, swap.secretHash, now);\n', '  }\n', '  // BTC Owner withdraw money and adds secret key to swap\n', '  // BTC Owner receive +1 reputation\n', '  function withdrawOther(bytes32 _secret, address _ownerAddress, address participantAddress) public {\n', '    Swap memory swap = swaps[_ownerAddress][participantAddress];\n', '\n', '    require(swap.secretHash == ripemd160(abi.encodePacked(_secret)));\n', '    require(swap.balance > uint256(0));\n', '    require(swap.createdAt.add(SafeTime) > now);\n', '\n', '    uint256 actualValue = swap.balance;\n', '    \n', '    uint256 tradeFee = actualValue.div(exchangeFee);\n', '    uint256 balanceAfterDeduction = actualValue.sub(tradeFee);\n', '\n', '    swap.targetWallet.transfer(balanceAfterDeduction);\n', '    exchangeFeeAddress.transfer(tradeFee);\n', '\n', '    swaps[_ownerAddress][participantAddress].balance = 0;\n', '    swaps[_ownerAddress][participantAddress].secret = _secret;\n', '\n', '    emit Withdraw(participantAddress, _ownerAddress, swap.secretHash, now);\n', '  }\n', '\n', '  // ETH Owner receive secret\n', '  function getSecret(address _participantAddress) public view returns (bytes32) {\n', '    return swaps[msg.sender][_participantAddress].secret;\n', '  }\n', '\n', '  event Close(address _buyer, address _seller);\n', '\n', '\n', '\n', '  event Refund(address _buyer, address _seller, bytes20 _secretHash);\n', '\n', '  // ETH Owner refund money\n', '  // BTC Owner gets -1 reputation\n', '  function refund(address _participantAddress) public {\n', '    Swap memory swap = swaps[msg.sender][_participantAddress];\n', '\n', '    require(swap.balance > uint256(0));\n', '    require(swap.createdAt.add(SafeTime) < now);\n', '\n', '    msg.sender.transfer(swap.balance);\n', '\n', '    clean(msg.sender, _participantAddress);\n', '\n', '    emit Refund(_participantAddress, msg.sender, swap.secretHash);\n', '  }\n', '\n', '  function clean(address _ownerAddress, address _participantAddress) internal {\n', '    delete swaps[_ownerAddress][_participantAddress];\n', '    delete participantSigns[_ownerAddress][_participantAddress];\n', '  }\n', '}\n', '\n', 'library SafeMath {\n', '    /**\n', '    * @dev Multiplies two unsigned integers, reverts on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two unsigned integers, reverts on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}']