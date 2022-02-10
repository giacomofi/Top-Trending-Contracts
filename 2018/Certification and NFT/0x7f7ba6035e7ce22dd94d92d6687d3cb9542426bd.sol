['// Ethertote - TeamTokens time-locked smart contract\n', '//\n', '// The following contract offers peace of mind to investors as the\n', '// Tokens that will go to the members of the Ethertote team\n', '// will be time-locked whereby a maximum of 25% of the Tokens can be withdrawn\n', '// from the smart contract every 3 months, starting from December 1st 2018\n', '//\n', '// Withdraw functions can only be called when the current timestamp is \n', '// greater than the time specified in each function\n', '// ----------------------------------------------------------------------------\n', '\n', 'pragma solidity 0.4.24;\n', '\n', '///////////////////////////////////////////////////////////////////////////////\n', '// SafeMath Library \n', '///////////////////////////////////////////////////////////////////////////////\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Imported Token Contract functions\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract EthertoteToken {\n', '    function thisContractAddress() public pure returns (address) {}\n', '    function balanceOf(address) public pure returns (uint256) {}\n', '    function transfer(address, uint) public {}\n', '}\n', '\n', '\n', '///////////////////////////////////////////////////////////////////////////////\n', '// Main contract\n', '//////////////////////////////////////////////////////////////////////////////\n', '\n', 'contract TeamTokens {\n', '    using SafeMath for uint256;\n', '    \n', '    EthertoteToken public token;\n', '\n', '    address public admin;\n', '    address public thisContractAddress;\n', '    \n', '    address public tokenContractAddress = 0x42be9831FFF77972c1D0E1eC0aA9bdb3CaA04D47;\n', '    \n', '    // the first team withdrawal can be made after:\n', '    // GMT: Saturday, 1 December 2018 00:00:00\n', '    // expressed as Unix epoch time \n', '    // https://www.epochconverter.com/\n', '    uint256 public unlockDate1 = 1543622400;\n', '    \n', '    // the second team withdrawal can be made after:\n', '    // GMT: Friday, 1 March 2019 00:00:00\n', '    // expressed as Unix epoch time \n', '    // https://www.epochconverter.com/\n', '    uint256 public unlockDate2 = 1551398400;\n', '    \n', '    // the third team withdrawal can be made after:\n', '    // GMT: Saturday, 1 June 2019 00:00:00\n', '    // expressed as Unix epoch time \n', '    // https://www.epochconverter.com/\n', '    uint256 public unlockDate3 = 1559347200;\n', '    \n', '    // the final team withdrawal can be made after:\n', '    // GMT: Sunday, 1 September 2019 00:00:00\n', '    // expressed as Unix epoch time \n', '    // https://www.epochconverter.com/\n', '    uint256 public unlockDate4 = 1567296000;\n', '    \n', '    // time of the contract creation\n', '    uint256 public createdAt;\n', '    \n', '    // amount of tokens that will be claimed\n', '    uint public tokensToBeClaimed;\n', '    \n', '    // ensure the function is only called once\n', '    bool public claimAmountSet;\n', '    \n', '    // percentage that the team can withdraw tokens\n', '    // it can naturally be inferred that quarter4 will also be 25%\n', '    uint public percentageQuarter1 = 25;\n', '    uint public percentageQuarter2 = 25;\n', '    uint public percentageQuarter3 = 25;\n', '    \n', '    // 100%\n', '    uint public hundredPercent = 100;\n', '    \n', '    // calculating the number used as the divider\n', '    uint public quarter1 = hundredPercent.div(percentageQuarter1);\n', '    uint public quarter2 = hundredPercent.div(percentageQuarter2);\n', '    uint public quarter3 = hundredPercent.div(percentageQuarter3);\n', '    \n', '    bool public withdraw_1Completed;\n', '    bool public withdraw_2Completed;\n', '    bool public withdraw_3Completed;\n', '\n', '\n', '    // MODIFIER\n', '    modifier onlyAdmin {\n', '        require(msg.sender == admin);\n', '        _;\n', '    }\n', '    \n', '    // EVENTS\n', '    event ReceivedTokens(address from, uint256 amount);\n', '    event WithdrewTokens(address tokenContract, address to, uint256 amount);\n', '\n', '    constructor () public {\n', '        admin = msg.sender;\n', '        thisContractAddress = address(this);\n', '        createdAt = now;\n', '        \n', '        thisContractAddress = address(this);\n', '\n', '        token = EthertoteToken(tokenContractAddress);\n', '    }\n', '    \n', '      // check balance of this smart contract\n', '  function thisContractTokenBalance() public view returns(uint) {\n', '      return token.balanceOf(thisContractAddress);\n', '  }\n', '  \n', '  function thisContractBalance() public view returns(uint) {\n', '      return address(this).balance;\n', '  }\n', '\n', '    // keep any ether sent to this address\n', '    function() payable public { \n', '        emit ReceivedTokens(msg.sender, msg.value);\n', '    }\n', '\n', '    function setTokensToBeClaimed() onlyAdmin public {\n', '        require(claimAmountSet == false);\n', '        tokensToBeClaimed = token.balanceOf(thisContractAddress);\n', '        claimAmountSet = true;\n', '    }\n', '\n', '\n', '    // callable by owner only, after specified time\n', '    function withdraw1() onlyAdmin public {\n', '       require(now >= unlockDate1);\n', '       require(withdraw_1Completed == false);\n', '       require(claimAmountSet == true);\n', '       // now allow a percentage of the balance\n', '       token.transfer(admin, (tokensToBeClaimed.div(quarter1)));\n', '       \n', '       emit WithdrewTokens(thisContractAddress, admin, (tokensToBeClaimed.div(quarter1)));    // 25%\n', '       withdraw_1Completed = true;\n', '    }\n', '    \n', '    // callable by owner only, after specified time\n', '    function withdraw2() onlyAdmin public {\n', '       require(now >= unlockDate2);\n', '       require(withdraw_2Completed == false);\n', '       require(claimAmountSet == true);\n', '       // now allow a percentage of the balance\n', '       token.transfer(admin, (tokensToBeClaimed.div(quarter2)));\n', '       \n', '       emit WithdrewTokens(thisContractAddress, admin, (tokensToBeClaimed.div(quarter2)));    // 25%\n', '       withdraw_2Completed = true;\n', '    }\n', '    \n', '    // callable by owner only, after specified time\n', '    function withdraw3() onlyAdmin public {\n', '       require(now >= unlockDate3);\n', '       require(withdraw_3Completed == false);\n', '       require(claimAmountSet == true);\n', '       // now allow a percentage of the balance\n', '       token.transfer(admin, (tokensToBeClaimed.div(quarter3)));\n', '       \n', '       emit WithdrewTokens(thisContractAddress, admin, (tokensToBeClaimed.div(quarter3)));    // 25%\n', '       withdraw_3Completed = true;\n', '    }\n', '    \n', '    // callable by owner only, after specified time\n', '    function withdraw4() onlyAdmin public {\n', '       require(now >= unlockDate4);\n', '       require(withdraw_3Completed == true);\n', '       // now allow a percentage of the balance\n', '       token.transfer(admin, (thisContractTokenBalance()));\n', '       \n', '       emit WithdrewTokens(thisContractAddress, admin, (thisContractTokenBalance()));    // 25%\n', '    }\n', '    \n', '    \n', '    function infoWithdraw1() public view returns(address, uint256, uint256, uint256) {\n', '        return (admin, unlockDate1, createdAt, (tokensToBeClaimed.div(quarter1)));\n', '    }\n', '\n', '    function infoWithdraw2() public view returns(address, uint256, uint256, uint256) {\n', '        return (admin, unlockDate2, createdAt, (tokensToBeClaimed.div(quarter2)));\n', '    }\n', '    \n', '    function infoWithdraw13() public view returns(address, uint256, uint256, uint256) {\n', '        return (admin, unlockDate3, createdAt, (tokensToBeClaimed.div(quarter3)));\n', '    }\n', '    \n', '    function infoWithdraw4() public view returns(address, uint256, uint256, uint256) {\n', '        return (admin, unlockDate4, createdAt, (thisContractTokenBalance()));\n', '    }\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// This method can be used by admin to extract Eth accidentally \n', '// sent to this smart contract after all previous transfers have been made\n', '// to the correct addresses\n', '// ----------------------------------------------------------------------------\n', '    function ClaimEth() onlyAdmin public {\n', '        require(address(this).balance > 0);\n', '        address(admin).transfer(address(this).balance);\n', '\n', '    }\n', '\n', '\n', '}']