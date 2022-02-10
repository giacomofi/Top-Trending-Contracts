['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-08\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.8.0;\n', '\n', '\n', '\n', '// File: BusStation.sol\n', '\n', 'contract BusStation {\n', '    /* ==== Variables ===== */\n', '\n', '    mapping(address => uint256) public _seats;\n', '    bool public _hasBusLeft;\n', '    uint256 public _ticketTotalValue;\n', '    uint256 public _minTicketValue = 0;\n', '    uint256 public _maxTicketValue;\n', '    uint256 public _minWeiToLeave;\n', '    address payable private _destination;\n', '\n', '    uint256 public _timelockDuration;\n', '    uint256 public _endOfTimelock;\n', '\n', '    /* ==== Events ===== */\n', '\n', '    /* \n', '    Removed for not being necessary and inflating gas costs\n', '    event TicketPurchased(address indexed _from, uint256 _value); \n', '    event Withdrawal(address indexed _from, uint256 _value);\n', '    event BusDeparts(uint256 _value);\n', '    */\n', '\n', '    /* ==== Constructor ===== */\n', '\n', '    // Set up a one-way bus ride to a destination, with reserve price, time of departure, and cap on ticket prices for fairness\n', '    constructor(\n', '        address payable destination,\n', '        uint256 minWeiToLeave,\n', '        uint256 timelockSeconds,\n', '        uint256 maxTicketValue\n', '    ) {\n', '        _hasBusLeft = false;\n', '        _minWeiToLeave = minWeiToLeave;\n', '        _maxTicketValue = maxTicketValue;\n', '        _destination = destination;\n', '        _timelockDuration = timelockSeconds;\n', '        _endOfTimelock = block.timestamp + _timelockDuration;\n', '    }\n', '\n', '    /* ==== Functions ===== */\n', '\n', '    // Purchase a bus ticket if eligible\n', '    function buyBusTicket() external payable canPurchaseTicket {\n', '        uint256 seatvalue = _seats[msg.sender];\n', '        require(\n', '            msg.value + seatvalue <= _maxTicketValue,\n', '            "Cannot exceed max ticket value."\n', '        );\n', '        _seats[msg.sender] = msg.value + seatvalue;\n', '        _ticketTotalValue += msg.value;\n', '        /* emit TicketPurchased(msg.sender, msg.value); */\n', '    }\n', '\n', '    // If bus is eligible, anybody can trigger the bus ride\n', '    function triggerBusRide() external isReadyToRide {\n', '        uint256 amount = _ticketTotalValue;\n', '        _ticketTotalValue = 0;\n', '        _hasBusLeft = true;\n', '        _destination.transfer(amount);\n', '        /* emit BusDeparts(amount); */\n', '    }\n', '\n', '    // If eligible to withdraw, then pull money out\n', '    function withdraw() external {\n', '        // Cannot withdraw after bus departs\n', '        require(_hasBusLeft == false, "Bus has already left.");\n', '\n', '        // Retrieve user balance\n', '        uint256 amount = _seats[msg.sender];\n', '        require(amount > 0, "Address does not have a ticket.");\n', '\n', '        // Write data before transfer to guard against re-entrancy\n', '        _seats[msg.sender] = 0;\n', '        _ticketTotalValue -= amount;\n', '        payable(msg.sender).transfer(amount);\n', '        /* emit Withdrawal(msg.sender, amount); */\n', '    }\n', '\n', '    /* === Modifiers === */\n', '\n', '    // Can only purchase ticket if bus has not left and ticket purchase amount is small\n', '    modifier canPurchaseTicket() {\n', '        require(_hasBusLeft == false, "The bus already left.");\n', '        require(msg.value > _minTicketValue, "Need to pay more for ticket.");\n', '        _;\n', '    }\n', '\n', '    // Bus can ride if timelock is passed and tickets exceed reserve price\n', '    modifier isReadyToRide() {\n', '        require(_endOfTimelock <= block.timestamp, "Function is timelocked.");\n', '        require(_hasBusLeft == false, "Bus is already gone.");\n', '        require(_ticketTotalValue >= _minWeiToLeave, "Not enough wei to leave.");\n', '        _;\n', '    }\n', '}']