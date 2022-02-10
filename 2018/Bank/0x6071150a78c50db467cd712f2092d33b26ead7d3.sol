['pragma solidity ^0.4.20;\n', '\n', 'contract SSC_HowManyPeoplePaid {\n', ' \n', '    event Bought(address _address);\n', '    event PriceUpdated(uint256 _price);\n', ' \n', '    // Owner of the contract\n', '    address private _owner;\n', ' \n', '    // The amount of curious people\n', '    uint256 private _count = 0;\n', '    // Price to take a look\n', '    uint256 private _price = 1500000000000000;\n', '    \n', '    // Only update the counter if the mapping is false. This ensures uniqueness.\n', '    mapping (address => bool) _clients;\n', '    \n', '    constructor() public {\n', '        _owner = msg.sender;   \n', '    }\n', '    \n', '   function withdraw() public{\n', '        require(msg.sender == _owner);\n', '        _owner.transfer(address(this).balance);\n', '    }\n', '    \n', '    // == Payables == //\n', '    \n', '    function() public payable { }\n', '    \n', '    function buy() public payable {\n', '        // Price must be at least _price, can be higher.\n', '        assert(msg.value >= _price);\n', '        \n', '        // No mapping exists? Unique! Increase counter.\n', '        if (!_clients[msg.sender]) {\n', '            _clients[msg.sender] = true;\n', '            _count += 1;\n', '        }\n', '        \n', '        // Emit an event\n', '        emit Bought(msg.sender);\n', '    }\n', '    \n', '    // == Setters == //\n', '    \n', '    function setPrice(uint256 newPrice) public {\n', '        require(msg.sender == _owner);\n', '        assert(newPrice > 0);\n', '        \n', '        // Set value\n', '        _price = newPrice;\n', '        \n', '        // Emit an event\n', '        emit PriceUpdated(newPrice);\n', '    }\n', '    \n', '    // == Getters == //\n', '    \n', '    function getBalance() public view returns (uint256) {\n', '        return address(this).balance;\n', '    }\n', '    \n', '    function getPrice() public view returns (uint256) {\n', '        return _price;\n', '    }\n', '    \n', '    // Will only return if this address exists in the mapping _clients.\n', '    // - Only paying customers can see this counter\n', '    // - If the customer has paid, he has life-time access\n', '    function getCount() public view returns (bool, uint256) {\n', '        if(_clients[msg.sender]){\n', '            return (true,_count);    \n', '        }\n', '        return (false, 0);\n', '    }\n', '    \n', '    function isClient(address _address) public view returns (bool) {\n', '        return _clients[_address];\n', '    }\n', '}']