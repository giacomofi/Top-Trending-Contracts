['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * IAME PRIVATE SALE CONTRACT\n', ' *\n', ' * Version 0.1\n', ' *\n', ' * Author IAME Limited\n', ' *\n', ' * MIT LICENSE Copyright 2018 IAME Limited\n', ' *\n', ' * Permission is hereby granted, free of charge, to any person obtaining a copy\n', ' * of this software and associated documentation files (the "Software"), to deal\n', ' * in the Software without restriction, including without limitation the rights\n', ' * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n', ' * copies of the Software, and to permit persons to whom the Software is\n', ' * furnished to do so, subject to the following conditions:\n', ' * The above copyright notice and this permission notice shall be included in\n', ' * all copies or substantial portions of the Software.\n', ' * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n', ' * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n', ' * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n', ' * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n', ' * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n', ' * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n', ' * SOFTWARE.\n', ' **/\n', '\n', '/**\n', ' *\n', ' * Important information about the IAME Token Private Sale\n', ' *\n', ' * For details about the IAME Token Private Sale, and in particular to find out\n', ' * about risks and limitations, please visit:\n', ' *\n', ' * https://www.iame.io\n', ' * \n', ' **/\n', ' \n', '/**\n', ' * Private Sale Contract Guide:\n', ' * \n', ' * Start Date: 18 April 2018.\n', ' * Contributions to this contract made before Start Date will be returned to sender.\n', ' * Closing Date: 20 May 2018 at 2018.\n', ' * Contributions to this contract made after End Date will be returned to sender.\n', ' * Minimum Contribution for this Private Sale is 1 Ether.\n', ' * Contributions of less than 1 Ether will be returned to sender.\n', ' * Contributors will receive IAM Tokens at the rate of 20,000 IAM per Ether.\n', ' * IAM Tokens will not be transferred to any other address than the contributing address.\n', ' * IAM Tokens will be distributed to contributing address no later than 3 weeks after ICO Start.\n', ' *\n', ' **/\n', '\n', '\n', 'contract Owned {\n', '  address public owner;\n', '\n', '  function Owned() internal{\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    if (msg.sender != owner) {\n', '      revert();\n', '    }\n', '    _;\n', '  }\n', '}\n', '\n', '/// ----------------------------------------------------------------------------------------\n', '/// @title IAME Private Sale Contract\n', '/// @author IAME Ltd\n', '/// @dev Changes to this contract will invalidate any security audits done before.\n', '/// ----------------------------------------------------------------------------------------\n', 'contract IAMEPrivateSale is Owned {\n', '  // -------------------------------------------------------------------------------------\n', '  // TODO Before deployment of contract to Mainnet\n', '  // 1. Confirm MINIMUM_PARTICIPATION_AMOUNT below\n', '  // 2. Adjust PRIVATESALE_START_DATE and confirm the Private Sale period\n', '  // 3. Test the deployment to a dev blockchain or Testnet\n', '  // 4. A stable version of Solidity has been used. Check for any major bugs in the\n', '  //    Solidity release announcements after this version.\n', '  // -------------------------------------------------------------------------------------\n', '\n', '  // Keep track of the total funding amount\n', '  uint256 public totalFunding;\n', '\n', '  // Minimum amount per transaction for public participants\n', '  uint256 public constant MINIMUM_PARTICIPATION_AMOUNT = 1 ether;\n', '\n', '  // Private Sale period\n', '  uint256 public PRIVATESALE_START_DATE;\n', '  uint256 public PRIVATESALE_END_DATE;\n', '\n', '  /// @notice This is the constructor to set the dates\n', '  function IAMEPrivateSale() public{\n', '    PRIVATESALE_START_DATE = now + 5 days; // &#39;now&#39; is the block timestamp\n', '    PRIVATESALE_END_DATE = now + 40 days;\n', '  }\n', '\n', '  /// @notice Keep track of all participants contributions, including both the\n', '  ///         preallocation and public phases\n', '  /// @dev Name complies with ERC20 token standard, etherscan for example will recognize\n', '  ///      this and show the balances of the address\n', '  mapping (address => uint256) public balanceOf;\n', '\n', '  /// @notice Log an event for each funding contributed during the public phase\n', '  event LogParticipation(address indexed sender, uint256 value, uint256 timestamp);\n', '\n', '\n', '  /// @notice A participant sends a contribution to the contract&#39;s address\n', '  ///         between the PRIVATESALE_STATE_DATE and the PRIVATESALE_END_DATE\n', '  /// @notice Only contributions bigger than the MINIMUM_PARTICIPATION_AMOUNT\n', '  ///         are accepted. Otherwise the transaction\n', '  ///         is rejected and contributed amount is returned to the participant&#39;s\n', '  ///         account\n', '  /// @notice A participant&#39;s contribution will be rejected if the Private Sale\n', '  ///         has been funded to the maximum amount\n', '  function () public payable {\n', '    // A participant cannot send funds before the Private Sale Start Date\n', '    if (now < PRIVATESALE_START_DATE) revert();\n', '    // A participant cannot send funds after the Private Sale End Date\n', '    if (now > PRIVATESALE_END_DATE) revert();\n', '    // A participant cannot send less than the minimum amount\n', '    if (msg.value < MINIMUM_PARTICIPATION_AMOUNT) revert();\n', '    // Register the participant&#39;s contribution\n', '    addBalance(msg.sender, msg.value);\n', '  }\n', '\n', '  /// @notice The owner can withdraw ethers already during Private Sale,\n', '  function ownerWithdraw(uint256 value) external onlyOwner {\n', '    if (!owner.send(value)) revert();\n', '  }\n', '\n', '  /// @dev Keep track of participants contributions and the total funding amount\n', '  function addBalance(address participant, uint256 value) private {\n', '    // Participant&#39;s balance is increased by the sent amount\n', '    balanceOf[participant] = safeIncrement(balanceOf[participant], value);\n', '    // Keep track of the total funding amount\n', '    totalFunding = safeIncrement(totalFunding, value);\n', '    // Log an event of the participant&#39;s contribution\n', '    LogParticipation(participant, value, now);\n', '  }\n', '\n', '  /// @dev Add a number to a base value. Detect overflows by checking the result is larger\n', '  ///      than the original base value.\n', '  function safeIncrement(uint256 base, uint256 increment) private pure returns (uint256) {\n', '    uint256 result = base + increment;\n', '    if (result < base) revert();\n', '    return result;\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * IAME PRIVATE SALE CONTRACT\n', ' *\n', ' * Version 0.1\n', ' *\n', ' * Author IAME Limited\n', ' *\n', ' * MIT LICENSE Copyright 2018 IAME Limited\n', ' *\n', ' * Permission is hereby granted, free of charge, to any person obtaining a copy\n', ' * of this software and associated documentation files (the "Software"), to deal\n', ' * in the Software without restriction, including without limitation the rights\n', ' * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n', ' * copies of the Software, and to permit persons to whom the Software is\n', ' * furnished to do so, subject to the following conditions:\n', ' * The above copyright notice and this permission notice shall be included in\n', ' * all copies or substantial portions of the Software.\n', ' * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n', ' * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n', ' * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n', ' * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n', ' * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n', ' * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n', ' * SOFTWARE.\n', ' **/\n', '\n', '/**\n', ' *\n', ' * Important information about the IAME Token Private Sale\n', ' *\n', ' * For details about the IAME Token Private Sale, and in particular to find out\n', ' * about risks and limitations, please visit:\n', ' *\n', ' * https://www.iame.io\n', ' * \n', ' **/\n', ' \n', '/**\n', ' * Private Sale Contract Guide:\n', ' * \n', ' * Start Date: 18 April 2018.\n', ' * Contributions to this contract made before Start Date will be returned to sender.\n', ' * Closing Date: 20 May 2018 at 2018.\n', ' * Contributions to this contract made after End Date will be returned to sender.\n', ' * Minimum Contribution for this Private Sale is 1 Ether.\n', ' * Contributions of less than 1 Ether will be returned to sender.\n', ' * Contributors will receive IAM Tokens at the rate of 20,000 IAM per Ether.\n', ' * IAM Tokens will not be transferred to any other address than the contributing address.\n', ' * IAM Tokens will be distributed to contributing address no later than 3 weeks after ICO Start.\n', ' *\n', ' **/\n', '\n', '\n', 'contract Owned {\n', '  address public owner;\n', '\n', '  function Owned() internal{\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    if (msg.sender != owner) {\n', '      revert();\n', '    }\n', '    _;\n', '  }\n', '}\n', '\n', '/// ----------------------------------------------------------------------------------------\n', '/// @title IAME Private Sale Contract\n', '/// @author IAME Ltd\n', '/// @dev Changes to this contract will invalidate any security audits done before.\n', '/// ----------------------------------------------------------------------------------------\n', 'contract IAMEPrivateSale is Owned {\n', '  // -------------------------------------------------------------------------------------\n', '  // TODO Before deployment of contract to Mainnet\n', '  // 1. Confirm MINIMUM_PARTICIPATION_AMOUNT below\n', '  // 2. Adjust PRIVATESALE_START_DATE and confirm the Private Sale period\n', '  // 3. Test the deployment to a dev blockchain or Testnet\n', '  // 4. A stable version of Solidity has been used. Check for any major bugs in the\n', '  //    Solidity release announcements after this version.\n', '  // -------------------------------------------------------------------------------------\n', '\n', '  // Keep track of the total funding amount\n', '  uint256 public totalFunding;\n', '\n', '  // Minimum amount per transaction for public participants\n', '  uint256 public constant MINIMUM_PARTICIPATION_AMOUNT = 1 ether;\n', '\n', '  // Private Sale period\n', '  uint256 public PRIVATESALE_START_DATE;\n', '  uint256 public PRIVATESALE_END_DATE;\n', '\n', '  /// @notice This is the constructor to set the dates\n', '  function IAMEPrivateSale() public{\n', "    PRIVATESALE_START_DATE = now + 5 days; // 'now' is the block timestamp\n", '    PRIVATESALE_END_DATE = now + 40 days;\n', '  }\n', '\n', '  /// @notice Keep track of all participants contributions, including both the\n', '  ///         preallocation and public phases\n', '  /// @dev Name complies with ERC20 token standard, etherscan for example will recognize\n', '  ///      this and show the balances of the address\n', '  mapping (address => uint256) public balanceOf;\n', '\n', '  /// @notice Log an event for each funding contributed during the public phase\n', '  event LogParticipation(address indexed sender, uint256 value, uint256 timestamp);\n', '\n', '\n', "  /// @notice A participant sends a contribution to the contract's address\n", '  ///         between the PRIVATESALE_STATE_DATE and the PRIVATESALE_END_DATE\n', '  /// @notice Only contributions bigger than the MINIMUM_PARTICIPATION_AMOUNT\n', '  ///         are accepted. Otherwise the transaction\n', "  ///         is rejected and contributed amount is returned to the participant's\n", '  ///         account\n', "  /// @notice A participant's contribution will be rejected if the Private Sale\n", '  ///         has been funded to the maximum amount\n', '  function () public payable {\n', '    // A participant cannot send funds before the Private Sale Start Date\n', '    if (now < PRIVATESALE_START_DATE) revert();\n', '    // A participant cannot send funds after the Private Sale End Date\n', '    if (now > PRIVATESALE_END_DATE) revert();\n', '    // A participant cannot send less than the minimum amount\n', '    if (msg.value < MINIMUM_PARTICIPATION_AMOUNT) revert();\n', "    // Register the participant's contribution\n", '    addBalance(msg.sender, msg.value);\n', '  }\n', '\n', '  /// @notice The owner can withdraw ethers already during Private Sale,\n', '  function ownerWithdraw(uint256 value) external onlyOwner {\n', '    if (!owner.send(value)) revert();\n', '  }\n', '\n', '  /// @dev Keep track of participants contributions and the total funding amount\n', '  function addBalance(address participant, uint256 value) private {\n', "    // Participant's balance is increased by the sent amount\n", '    balanceOf[participant] = safeIncrement(balanceOf[participant], value);\n', '    // Keep track of the total funding amount\n', '    totalFunding = safeIncrement(totalFunding, value);\n', "    // Log an event of the participant's contribution\n", '    LogParticipation(participant, value, now);\n', '  }\n', '\n', '  /// @dev Add a number to a base value. Detect overflows by checking the result is larger\n', '  ///      than the original base value.\n', '  function safeIncrement(uint256 base, uint256 increment) private pure returns (uint256) {\n', '    uint256 result = base + increment;\n', '    if (result < base) revert();\n', '    return result;\n', '  }\n', '\n', '}']