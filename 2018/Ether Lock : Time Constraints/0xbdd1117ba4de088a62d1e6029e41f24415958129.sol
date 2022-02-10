['pragma solidity ^0.4.21;\n', '\n', '/**\n', ' * @title Serpentio Contract <http://serpentio.com> - April 2018\n', ' * @Author Alber Erre <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="0e6f7c6c627b69614e69636f6762206d6163">[email&#160;protected]</a>> <http://albererre.com>\n', ' * Technical details here: https://medium.com/@alber_erre/serpentio-a-snake-on-the-ethereum-blockchain-non-linear-distribution-scheme-b116bfa187d8\n', ' */\n', '\n', '/**\n', ' * The Serpent contract distributes its acummulated balance between investors using a non-linear scheme, inside a period of time.\n', ' * As such, every new investor help to fund previous investors, under the promise that future new investors will fund itself.\n', ' * Result: Early investors receive more funds than last investors.\n', ' */\n', '\n', '/**\n', ' * Based on Open Zeppelin - https://github.com/OpenZeppelin/zeppelin-solidity\n', ' * \n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract Serpent is Ownable {\n', '\tusing SafeMath for uint256;\n', '\n', '\t// everyone should check this measure to find out how much they have earned.\n', '\tmapping (address => uint256) public investorReturn;\n', '\n', '\tuint256 public SerpenSegmentCount;\n', '\tuint256 public SerpentCountDown;\n', '\taddress public SerpentHead;\n', '\taddress[] investormapping;\n', '\n', '\tstruct investorDetails {\n', '\t    address investorAddress;\n', '\t    uint256 amountInvested;\n', '\t    uint256 SegmentNumber;\n', '\t    uint256 time;\n', '\t    string  quote;\n', '\t}\n', '\n', '\tinvestorDetails[] public investorsList;\n', '\n', '\tfunction Serpent () {\n', '\t\t// Constructor: init public variables and add creator as SerpentHead\n', '\t\tSerpentHead = owner;\n', '\t\tSerpenSegmentCount = 0;\n', '\t\tSerpentCountDown = uint256(block.timestamp);\n', '\t}\n', '\n', '\tfunction Play (string _quote) payable public {\n', '\n', '\t\trequire (msg.value > 0);\n', '        require (msg.sender != address(0)); // just in case\n', '        require (uint256(block.timestamp) < SerpentCountDown); // nobody can play once countdown is finished\n', '\n', '        address thisAddress = msg.sender;\n', '\t\tuint256 thisAmmount = msg.value;\n', '\n', '        AddReturnsMapping(thisAmmount);\n', '\t    // AddReturnsMapping MUST be before AddNewSegment, to avoid counting the new segment while calculating returns\n', '\n', '\t    SerpenSegmentCount = SerpenSegmentCount.add(1);\n', '\t\tAddNewSegment(thisAddress, thisAmmount, SerpenSegmentCount, uint256(block.timestamp), _quote);\n', '\t    // Adding new segment - the same address can send more than once.\n', '        // Although, distribution is based on chronological amounts, not addresses.\n', '\t}\n', '\n', '\t// Callback function\n', '\tfunction () payable public {\n', '\t\trequire(msg.value > 0);\n', '\n', '\t\tPlay("Callback, No quote");\n', '\t}\n', '\n', '\tfunction NewSerpent (uint256 _SerpentCountDown) public onlyOwner {\n', '\n', '\t\t// this is to avoid deleting current serpent game until the previous game has finished\n', '\t\trequire (uint256(block.timestamp) > SerpentCountDown);\n', '\t\t\n', '\t\tSerpenSegmentCount = 0;\n', '\t\tSerpentCountDown = _SerpentCountDown;\n', '\n', '\t\t//Collect prime-number reminders from previous game calculations\n', '\t\tuint256 nonPrimeReminders = 0;\n', '\t\tfor (uint256 p = 0; p < investormapping.length; p++) {\n', '\t\t\tnonPrimeReminders.add(investorReturn[investormapping[p]]);\n', '\t\t}\n', '\t\tuint256 PrimeReminder = uint256(address(this).balance) - nonPrimeReminders;\n', '\t\tSerpentHead.transfer(PrimeReminder);\n', '\n', '\t\t//Delete current investormapping array elements, to init new-serpent investormapping\n', '\t\twhile (investormapping.length != 0) {\n', '\t\t\tdelete investormapping[investormapping.length-1]; //delete last element\n', '\t\t\tinvestormapping.length--;\n', '\t\t}\n', '\n', '\t\t// Start first serpent segment\n', '\t    SerpenSegmentCount = SerpenSegmentCount.add(1);\n', '\t    investormapping.push(SerpentHead);\n', '\t    AddNewSegment(SerpentHead, 1 ether, SerpenSegmentCount, uint256(block.timestamp), "Everything started with Salazar Slytherin");\n', '\t}\n', '\t\n', '\t\n', '\tfunction AddNewSegment (address _address, uint256 _amount, uint256 _segmentNumber, uint256 _time, string _quote) internal {\n', '\t    require (_amount > 0); // just in case\n', '\n', '\t\t// in case this is a new address, add it to mappings, if not, just do nothing\n', '\t\tuint256 inList = 0;\n', '\t\tfor (uint256 n = 0; n < investormapping.length; n++) {\n', '\t\t\tif (investormapping[n] == _address) {\n', '\t\t\t\tinList = 1;\n', '\t\t\t}\n', '\t\t}\n', '\t\tif (inList == 0) {\n', '\t\t\tinvestorReturn[_address] = 0;\n', '\t\t\tinvestormapping.push(_address); //add only once per address\n', '\t\t}\n', '\n', '\t\t// add to struct list, but after inList check\n', '\t\tinvestorsList.push(investorDetails(_address, _amount, _segmentNumber, _time, _quote));\n', '\t}\n', '\n', '\tfunction AddReturnsMapping (uint256 _amount) internal {\n', '\n', '\t\tuint256 individualAmount = _amount.div(investormapping.length);\n', '\n', '\t\tfor (uint256 a = 0; a < investormapping.length; a++) {\n', '\t\t\tinvestorReturn[investormapping[a]] = investorReturn[investormapping[a]].add(individualAmount); \n', '\t\t}\n', '\t}\n', '\t\n', '\tfunction CollectReturns () external {\n', '\n', '\t\tuint256 currentTime = uint256(block.timestamp);\n', '\t\tuint256 amountToCollect = getReturns(msg.sender);\n', '\t\trequire (currentTime > SerpentCountDown); // collect if serpent has finished\n', '\t\trequire(address(this).balance >= amountToCollect);\n', '\n', '\t\taddress(msg.sender).transfer(amountToCollect);\n', '\t\tinvestorReturn[msg.sender] = 0;\n', '\t}\n', '\n', '\tfunction getBalance () public view returns(uint256) {\n', '\t\treturn uint256(address(this).balance);\n', '\t}\n', '\n', '\tfunction getParticipants () public view returns(uint256) {\n', '\t\treturn uint256(investormapping.length);\n', '\t}\n', '\n', '\tfunction getCountdownDate () public view returns(uint256) {\n', '\t\treturn uint256(SerpentCountDown);\n', '\t}\n', '\n', '\tfunction getReturns (address _address) public view returns(uint256) {\n', '\t\treturn uint256(investorReturn[_address]);\n', '\t}\n', '\t\n', '\tfunction SerpentIsRunning () public view returns(bool) {\n', '\t\treturn bool(uint256(block.timestamp) < SerpentCountDown);\n', '\t}\n', '\n', '  // End of contract\n', '}']