['pragma solidity 0.5.2;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '\n', 'contract IPolaris {\n', '    struct Checkpoint {\n', '        uint ethReserve;\n', '        uint tokenReserve;\n', '    }\n', '\n', '    struct Medianizer {\n', '        uint8 tail;\n', '        uint pendingStartTimestamp;\n', '        uint latestTimestamp;\n', '        Checkpoint[] prices;\n', '        Checkpoint[] pending;\n', '        Checkpoint median;\n', '    }\n', '    function subscribe(address token) public payable;\n', '    function unsubscribe(address token, uint amount) public returns (uint actualAmount);\n', '    function getMedianizer(address token) public view returns (Medianizer memory);\n', '    function getDestAmount(address src, address dest, uint srcAmount) public view returns (uint);\n', '}\n', '\n', '\n', 'contract MarbleSubscriber {\n', '\n', '    IPolaris public oracle;\n', '\n', '    constructor(address _oracle) public {\n', '        oracle = IPolaris(_oracle);\n', '    }\n', '\n', '    function subscribe(address asset) public payable returns (uint) {\n', '        oracle.subscribe.value(msg.value)(asset);\n', '    }\n', '\n', '    function getDestAmount(address src, address dest, uint srcAmount) public view returns (uint) {\n', '        return oracle.getDestAmount(src, dest, srcAmount);\n', '    }\n', '\n', '    function getMedianizer(address token) public view returns (IPolaris.Medianizer memory) {\n', '        return oracle.getMedianizer(token);\n', '    }\n', '}']