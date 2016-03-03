#if os(Linux)
    import CPostgreSQLLinux
#else
    import CPostgreSQLMac
#endif

import Fluent

public class PostgreSQLDialect : SQL {

    private let driver : PostgreSQLDriver

    public init(driver: PostgreSQLDriver, operation: Operation, table: String) {
        self.driver = driver
        super.init(operation: operation, table: table)
    }


    override public func quoteWord(word: String) -> String {
        return self.driver.escapeIdentifier(word)
    }

    override public func getData(key: String) -> String {
        if let data = self.data {
            if let val = data[key] {
                if val == "NULL" {
                    return val
                } else {
                    return self.driver.escapeLiteral(val)
                }
            }
        }
        return ""
    }

    override public func getFilterValue(filter: CompareFilter) -> String {
        return self.driver.escapeLiteral(filter.value)
    }

    override public func getFilterValue(filter: SubsetFilter) -> String {
        let superSet = filter.superSet.map { self.driver.escapeLiteral($0) }
        return superSet.joinWithSeparator(",")
    }
}
