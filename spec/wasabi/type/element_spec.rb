require 'spec_helper'

describe Wasabi::Type::Element do

  specify 'complexType/sequence/element' do
    element = new_element('
      <xs:element name="TermOfPayment" xmlns="http://www.w3.org/2001/XMLSchema"
                                       xmlns:tns="http://example.com">
        <xs:complexType>
          <xs:sequence>
            <xs:element minOccurs="0" maxOccurs="1" name="termOfPaymentHandle" type="tns:TermOfPaymentHandle" />
            <xs:element minOccurs="1" maxOccurs="1" name="value" nillable="true" type="xs:decimal" />
          </xs:sequence>
        </xs:complexType>
      </xs:element>
    ')

    expect(element).to be_a(Wasabi::Type::Element)

    complex_type = element.children.first
    expect(complex_type).to be_a(Wasabi::Type::ComplexType)

    sequence = complex_type.children.first
    expect(sequence).to be_a(Wasabi::Type::Sequence)

    elements = sequence.children
    expect(elements.count).to eq(2)

    expect(elements[0]).to be_a(Wasabi::Type::Element)
    expect(elements[0].name).to eq('termOfPaymentHandle')

    expect(elements[1]).to be_a(Wasabi::Type::Element)
    expect(elements[1].name).to eq('value')

    expect(element.collect_child_elements).to eq(elements)
  end

  specify 'element/complexType/sequence/choice/element' do
    element = new_element('
      <xs:element name="source">
        <xs:complexType>
          <xs:sequence>
            <xs:choice minOccurs="1">
              <xs:element name="account" type="tns:id"/>
              <xs:element name="linkedExternalAccountId" type="tns:id"/>
              <xs:element name="newExternalAccount" type="tns:collectExternalAccount"/>
            </xs:choice>
          </xs:sequence>
        </xs:complexType>
      </xs:element>
    ')

    expect(element).to be_a(Wasabi::Type::Element)
    expect(element.collect_child_elements.count).to eq(3)
  end

  specify 'element/complexType/sequence/choice/element' do
    element = new_element('
      <xsd:element name="commandGroup">
        <xsd:simpleType>
          <xsd:restriction base="xsd:string"/>
        </xsd:simpleType>
      </xsd:element>
    ')

    expect(element).to be_a(Wasabi::Type::Element)

    expect(element.collect_child_elements).to be_empty
    expect(element.type).to eq('xsd:string')
  end

  def new_element(xml)
    node = Nokogiri.XML(xml).root
    wsdl ||= mock('wsdl')
    schema = {}

    Wasabi::Type::Element.new(node, wsdl, schema)
  end

end
