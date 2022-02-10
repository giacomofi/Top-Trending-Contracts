['contract InvestmentAnalytics {\n', 'function iaInvestedBy(address investor) external payable;\n', '}\n', '\n', '/*\n', ' * @title This is proxy for analytics. Target contract can be found at field m_analytics (see "read contract").\n', ' * @author Eenae\n', '\n', ' * FIXME after fix of truffle issue #560: refactor to a separate contract file which uses InvestmentAnalytics interface\n', ' */\n', 'contract AnalyticProxy {\n', '\n', '    function AnalyticProxy() {\n', '        m_analytics = InvestmentAnalytics(msg.sender);\n', '    }\n', '\n', '    /// @notice forward payment to analytics-capable contract\n', '    function() payable {\n', '        m_analytics.iaInvestedBy.value(msg.value)(msg.sender);\n', '    }\n', '\n', '    InvestmentAnalytics public m_analytics;\n', '}']