['pragma solidity ^0.4.21;\n', '\n', '\n', 'library SafeMath {\n', '\tfunction add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tuint256 c = a + b;\n', '\t\tassert(a <= c);\n', '\t\treturn c;\n', '\t}\n', '\n', '\tfunction sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tassert(a >= b);\n', '\t\treturn a - b;\n', '\t}\n', '\n', '\tfunction mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tuint256 c = a * b;\n', '\t\tassert(a == 0 || c / a == b);\n', '\t\treturn c;\n', '\t}\n', '\n', '\tfunction div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\treturn a / b;\n', '\t}\n', '}\n', '\n', '\n', 'contract AuctusStepVesting {\n', '\tusing SafeMath for uint256;\n', '\n', '\taddress public beneficiary;\n', '\tuint256 public start;\n', '\tuint256 public cliff;\n', '\tuint256 public steps;\n', '\n', '\tuint256 public releasedSteps;\n', '\tuint256 public releasedAmount;\n', '\tuint256 public remainingAmount;\n', '\n', '\tevent Released(uint256 step, uint256 amount);\n', '\n', '\t/**\n', '\t* @dev Creates a vesting contract that vests its balance to the _beneficiary\n', '\t* The amount is released gradually in steps\n', '\t* @param _beneficiary address of the beneficiary to whom vested are transferred\n', '\t* @param _start unix time that starts to apply the vesting rules\n', '\t* @param _cliff duration in seconds of the cliff in which will begin to vest and between the steps\n', '\t* @param _steps total number of steps to release all the balance\n', '\t*/\n', '\tfunction AuctusStepVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _steps) public {\n', '\t\trequire(_beneficiary != address(0));\n', '\t\trequire(_steps > 0);\n', '\t\trequire(_cliff > 0);\n', '\n', '\t\tbeneficiary = _beneficiary;\n', '\t\tcliff = _cliff;\n', '\t\tstart = _start;\n', '\t\tsteps = _steps;\n', '\t}\n', '\n', '\tfunction transfer(uint256 amount) internal;\n', '\n', '\t/**\n', '\t* @notice Transfers vested tokens to beneficiary.\n', '\t*/\n', '\tfunction release() public {\n', '\t\tuint256 unreleased = getAllowedStepAmount();\n', '\n', '\t\trequire(unreleased > 0);\n', '\n', '\t\treleasedAmount = releasedAmount.add(unreleased);\n', '\t\tremainingAmount = remainingAmount.sub(unreleased);\n', '\t\tif (remainingAmount == 0) {\n', '\t\t\treleasedSteps = steps;\n', '\t\t} else {\n', '\t\t\treleasedSteps = releasedSteps + 1;\n', '\t\t}\n', '\n', '\t\ttransfer(unreleased);\n', '\n', '\t\temit Released(releasedSteps, unreleased);\n', '\t}\n', '\n', '\tfunction getAllowedStepAmount() public view returns (uint256) {\n', '\t\tif (remainingAmount == 0) {\n', '\t\t\treturn 0;\n', '\t\t} else if (now < start) {\n', '\t\t\treturn 0;\n', '\t\t} else {\n', '\t\t\tuint256 secondsFromTheBeginning = now.sub(start);\n', '\t\t\tif (secondsFromTheBeginning < cliff) {\n', '\t\t\t\treturn 0;\n', '\t\t\t} else {\n', '\t\t\t\tuint256 stepsAllowed = secondsFromTheBeginning.div(cliff);\n', '\t\t\t\tif (stepsAllowed >= steps) {\n', '\t\t\t\t\treturn remainingAmount;\n', '\t\t\t\t} else if (releasedSteps == stepsAllowed) {\n', '\t\t\t\t\treturn 0;\n', '\t\t\t\t} else {\n', '\t\t\t\t\treturn totalControlledBalance().div(steps);\n', '\t\t\t\t}\n', '\t\t\t}\n', '\t\t}\n', '\t}\n', '\n', '\tfunction totalControlledBalance() public view returns (uint256) {\n', '\t\treturn remainingAmount.add(releasedAmount);\n', '\t}\n', '}\n', '\n', '\n', 'contract AuctusEtherVesting is AuctusStepVesting {\n', '\tfunction AuctusEtherVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _steps) \n', '\t\tpublic \n', '\t\tAuctusStepVesting(_beneficiary, _start, _cliff, _steps) \n', '\t{\n', '\t}\n', '\n', '\tfunction transfer(uint256 amount) internal {\n', '\t\tbeneficiary.transfer(amount);\n', '\t}\n', '\n', '\tfunction () payable public {\n', '\t\tremainingAmount = remainingAmount.add(msg.value);\n', '\t}\n', '}\n', '\n', '\n', 'contract AuctusToken {\n', '\tfunction transfer(address to, uint256 value) public returns (bool);\n', '}\n', '\n', '\n', 'contract ContractReceiver {\n', '\tfunction tokenFallback(address from, uint256 value, bytes data) public;\n', '}\n', '\n', '\n', 'contract AuctusTokenVesting is AuctusStepVesting, ContractReceiver {\n', '\taddress public auctusTokenAddress = 0xfD89de68b246eB3e21B06e9B65450AC28D222488;\n', '\n', '\tfunction AuctusTokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _steps) \n', '\t\tpublic \n', '\t\tAuctusStepVesting(_beneficiary, _start, _cliff, _steps) \n', '\t{\n', '\t}\n', '\n', '\tfunction transfer(uint256 amount) internal {\n', '\t\tassert(AuctusToken(auctusTokenAddress).transfer(beneficiary, amount));\n', '\t}\n', '\n', '\tfunction tokenFallback(address from, uint256 value, bytes) public {\n', '\t\trequire(msg.sender == auctusTokenAddress);\n', '\t\tremainingAmount = remainingAmount.add(value);\n', '\t}\n', '}']