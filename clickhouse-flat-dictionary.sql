使用外部csv文件创建clickhouse dictionary

1.csv file organization.csv
1,"a0001","研发部"
2,"a0002","产品部"
3,"a0003","数据部"
4,"a0004","测试部"
5,"a0005","运维部"
6,"a0006","规划部"
7,"a0007","市场部"

2.test_flat1_dictionary.xml

<yandex>
    <dictionary>
        <name>ext-dict-test</name>
        <source>
            <file>
                <path>/etc/clickhouse-server/organization.csv</path>
                <format>CSV</format>
            </file>
        </source>
        <layout>
            <flat />
        </layout>
        <structure>
            <id>
                <name>id</name>
            </id>
            <attribute>
                <name>code</name>
                <type>String</type>
                <null_value></null_value>
            </attribute>
            <attribute>
                <name>name</name>
                <type>String</type>
                <null_value></null_value>
            </attribute>
        </structure>
        <lifetime>0</lifetime>
    </dictionary>
</yandex>

3.
SELECT
    name,
    type,
    key,
    attribute.names,
    attribute.types,
    bytes_allocated,
    element_count,
    source
FROM system.dictionaries
;

4.
SELECT
    number AS id,
    dictGetString('ext-dict-test', 'code', toUInt64(id)) AS code,
    dictGetString('ext-dict-test', 'name', toUInt64(id)) AS name
FROM system.numbers
LIMIT 10

┌─id─┬─code──┬─name───┐
│  0 │       │        │
│  1 │ a0001 │ 研发部 │
│  2 │ a0002 │ 产品部 │
│  3 │ a0003 │ 数据部 │
│  4 │ a0004 │ 测试部 │
│  5 │ a0005 │ 运维部 │
│  6 │ a0006 │ 规划部 │
│  7 │ a0007 │ 市场部 │
│  8 │       │        │
│  9 │       │        │
└────┴───────┴────────┘
