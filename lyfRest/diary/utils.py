from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from django.conf import settings
from reportlab import rl_config
from reportlab.lib.styles import ParagraphStyle
from reportlab.platypus import SimpleDocTemplate, Paragraph
from reportlab.lib.colors import HexColor
from reportlab.lib.units import mm
from reportlab.lib.enums import TA_JUSTIFY
from datetime import datetime

import io

from .models import DiaryEntry

class EntryPDFGenerator:
    def __init__(self, fontData: dict,):
        self.fontData = fontData
        self.registerFont()


    def textFormatter(self, text:str): 
        text = text.replace(' ','&nbsp;')
        text = text.replace('\n','<br />')
        text = text.replace('\t','&nbsp;&nbsp;&nbsp;&nbsp')
        return text

    def registerFont(self):

        for font in list(self.fontData.keys()):
            fontFile = self.fontData.get(font)
            rl_config.TTFSearchPath.append(str(settings.BASE_DIR) + "/static/fonts")
            newFont = TTFont(font, fontFile)
            pdfmetrics.registerFont(newFont)

    def drawLogo(self, canvas: canvas.Canvas, X, Y, width, height):
        
        # logoPath = str(settings.BASE_DIR) + "/static/assets/lyf.svg"
        # canvas.drawImage(
        #     logoPath,
        #      x=X, 
        #      y=Y, 
        #      width = width, 
        #      height= height
        # )

        pass
    

    def addPageNumber(self, canvas: canvas.Canvas, doc):
        pageNumber = canvas.getPageNumber()
        canvas.setFont("Caveat",18)
        text = f"lyf | {pageNumber}"
        canvas.setFillColorRGB(22/256,133/256,111/256)
        canvas.drawRightString(180*mm, 17.5*mm, text)


    def generateEntry(self, entry:DiaryEntry, file_buffer: io.BytesIO):

        self.entry = entry
        self.fileBuffer = file_buffer
        self.canva = canvas.Canvas(self.fileBuffer,pagesize=A4)
        self.canva.setCreator("Lyf")
        # self.drawLogo(canvas=self.canva,)

        parts = []
        
        title = self.textFormatter(self.entry.asDict['_title'])
        dateObj = datetime.fromisoformat(self.entry.asDict["_createdAt"]).date()
        dateText = dateObj.strftime("%B %d, %Y")
        lineBreak = "&nbsp;&nbsp;<br />"
        description = self.textFormatter(self.entry.asDict['_description'])

        titleStyle = ParagraphStyle(
            name="Title",
            fontName="Ubuntu",
            fontSize=25,
            textColor=HexColor("#16856f")
        )
        dateStyle = ParagraphStyle(
            name="Date", 
            fontName = "ABZee",
            fontSize = 9, 
            fontStyle = "italic",
            textColor=HexColor("#ff5e0e")
        )
        descriptionStyle = ParagraphStyle(
            name='Description',
            fontName='ABZee',
            fontSize=10,
            leading=15,
            wordWrap="CJK",
            alignment=TA_JUSTIFY
            # textColor=HexColor("#695d46")
        )

        parts.append(Paragraph(dateText, style=dateStyle))
        parts.append(Paragraph(title, style = titleStyle))
        parts.append(Paragraph(lineBreak, style=titleStyle))
        parts.append(Paragraph(lineBreak, style=titleStyle))
        parts.append(Paragraph(lineBreak, style=titleStyle))
        parts.append(Paragraph(description, style = descriptionStyle))
        summaryName = SimpleDocTemplate(
            self.fileBuffer, 
            title=self.entry.asDict['_title'], 
            creator="Lyf", 
            author=entry._user.username, 
            subject=entry._user.username+"'s "+self.entry.asDict['_title']
            )
        summaryName.build(
            parts,
            onFirstPage=self.addPageNumber, 
            onLaterPages=self.addPageNumber
        )

        return self.fileBuffer

fontData = {
    "ABZee": "ABeeZee-Regular.ttf",
    "Ubuntu": "Ubuntu-Regular.ttf",
    "Caveat": "Caveat-Regular.ttf"
}

DiaryGenerator = EntryPDFGenerator(fontData=fontData)