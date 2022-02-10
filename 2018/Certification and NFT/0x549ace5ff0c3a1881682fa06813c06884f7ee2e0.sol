['pragma solidity ^0.4.18;\n', ' \n', '/**\n', ' * Copyright 2018, Flowchain.co\n', ' *\n', ' * The FlowchainCoin (FLC) smart contract of private sale Round A\n', ' */\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    int256 constant private INT256_MIN = -2**255;\n', '\n', '    /**\n', '    * @dev Multiplies two unsigned integers, reverts on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Multiplies two signed integers, reverts on overflow.\n', '    */\n', '    function mul(int256 a, int256 b) internal pure returns (int256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below\n', '\n', '        int256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(int256 a, int256 b) internal pure returns (int256) {\n', '        require(b != 0); // Solidity only automatically asserts when dividing by 0\n', '        require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow\n', '\n', '        int256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two signed integers, reverts on overflow.\n', '    */\n', '    function sub(int256 a, int256 b) internal pure returns (int256) {\n', '        int256 c = a - b;\n', '        require((b >= 0 && c <= a) || (b < 0 && c > a));\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two unsigned integers, reverts on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two signed integers, reverts on overflow.\n', '    */\n', '    function add(int256 a, int256 b) internal pure returns (int256) {\n', '        int256 c = a + b;\n', '        require((b >= 0 && c >= a) || (b < 0 && c < a));\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'interface Token {\n', '    function mintToken(address to, uint amount) external returns (bool success);  \n', '    function setupMintableAddress(address _mintable) public returns (bool success);\n', '}\n', '\n', 'contract MintableSale {\n', '    // @notice Create a new mintable sale\n', '    /// @param rate The exchange rate\n', '    /// @param fundingGoalInEthers The funding goal in ethers\n', '    /// @param durationInMinutes The duration of the sale in minutes\n', '    /// @return \n', '    function createMintableSale(uint256 rate, uint256 fundingGoalInEthers, uint durationInMinutes) external returns (bool success);\n', '}\n', '\n', 'contract EarlyTokenSale is MintableSale {\n', '    using SafeMath for uint256;\n', '    uint256 public fundingGoal;\n', '    uint256 public tokensPerEther;\n', '    uint public deadline;\n', '    address public multiSigWallet;\n', '    uint256 public amountRaised;\n', '    Token public tokenReward;\n', '    mapping(address => uint256) public balanceOf;\n', '    bool fundingGoalReached = false;\n', '    bool crowdsaleClosed = false;\n', '    address public creator;\n', '    address public addressOfTokenUsedAsReward;\n', '    bool public isFunding = false;\n', '\n', '    /* accredited investors */\n', '    mapping (address => uint256) public accredited;\n', '\n', '    event FundTransfer(address backer, uint amount);\n', '\n', '    /* Constrctor function */\n', '    function EarlyTokenSale(\n', '        address _addressOfTokenUsedAsReward\n', '    ) payable {\n', '        creator = msg.sender;\n', '        multiSigWallet = 0x9581973c54fce63d0f5c4c706020028af20ff723;\n', '        // Token Contract\n', '        addressOfTokenUsedAsReward = _addressOfTokenUsedAsReward;\n', '        tokenReward = Token(addressOfTokenUsedAsReward);\n', '        // Setup accredited investors\n', '        setupAccreditedAddress(0xec7210E3db72651Ca21DA35309A20561a6F374dd, 1000);\n', '    }\n', '\n', '    // @dev Start a new mintable sale.\n', '    // @param rate The exchange rate in ether, for example 1 ETH = 6400 FLC\n', '    // @param fundingGoalInEthers\n', '    // @param durationInMinutes\n', '    function createMintableSale(uint256 rate, uint256 fundingGoalInEthers, uint durationInMinutes) external returns (bool success) {\n', '        require(msg.sender == creator);\n', '        require(isFunding == false);\n', '        require(rate <= 6400 && rate >= 1);                   // rate must be between 1 and 6400\n', '        require(fundingGoalInEthers >= 1000);        \n', '        require(durationInMinutes >= 60 minutes);\n', '\n', '        deadline = now + durationInMinutes * 1 minutes;\n', '        fundingGoal = amountRaised + fundingGoalInEthers * 1 ether;\n', '        tokensPerEther = rate;\n', '        isFunding = true;\n', '        return true;    \n', '    }\n', '\n', '    modifier afterDeadline() { if (now > deadline) _; }\n', '    modifier beforeDeadline() { if (now <= deadline) _; }\n', '\n', '    /// @param _accredited The address of the accredited investor\n', '    /// @param _amountInEthers The amount of remaining ethers allowed to invested\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function setupAccreditedAddress(address _accredited, uint _amountInEthers) public returns (bool success) {\n', '        require(msg.sender == creator);    \n', '        accredited[_accredited] = _amountInEthers * 1 ether;\n', '        return true;\n', '    }\n', '\n', '    /// @dev This function returns the amount of remaining ethers allowed to invested\n', '    /// @return The amount\n', '    function getAmountAccredited(address _accredited) view returns (uint256) {\n', '        uint256 amount = accredited[_accredited];\n', '        return amount;\n', '    }\n', '\n', '    function closeSale() beforeDeadline {\n', '        require(msg.sender == creator);    \n', '        isFunding = false;\n', '    }\n', '\n', '    // change creator address\n', '    function changeCreator(address _creator) external {\n', '        require(msg.sender == creator);\n', '        creator = _creator;\n', '    }\n', '\n', '    /// @dev This function returns the current exchange rate during the sale\n', '    /// @return The address of token creator\n', '    function getRate() beforeDeadline view returns (uint) {\n', '        return tokensPerEther;\n', '    }\n', '\n', '    /// @dev This function returns the amount raised in wei\n', '    /// @return The address of token creator\n', '    function getAmountRaised() view returns (uint) {\n', '        return amountRaised;\n', '    }\n', '\n', '    function () payable {\n', '        // check if we can offer the private sale\n', '        require(isFunding == true && amountRaised < fundingGoal);\n', '\n', '        // the minimum deposit is 1 ETH\n', '        uint256 amount = msg.value;        \n', '        require(amount >= 1 ether);\n', '\n', '        require(accredited[msg.sender] - amount >= 0); \n', '\n', '        multiSigWallet.transfer(amount);      \n', '        balanceOf[msg.sender] += amount;\n', '        accredited[msg.sender] -= amount;\n', '        amountRaised += amount;\n', '        FundTransfer(msg.sender, amount);\n', '\n', '        uint256 value = amount.mul(tokensPerEther);        \n', '        tokenReward.mintToken(msg.sender, value);        \n', '    }\n', '}']